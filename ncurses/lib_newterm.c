
/***************************************************************************
*                            COPYRIGHT NOTICE                              *
****************************************************************************
*                ncurses is copyright (C) 1992-1995                        *
*                          Zeyd M. Ben-Halim                               *
*                          zmbenhal@netcom.com                             *
*                          Eric S. Raymond                                 *
*                          esr@snark.thyrsus.com                           *
*                                                                          *
*        Permission is hereby granted to reproduce and distribute ncurses  *
*        by any means and for any fee, whether alone or as part of a       *
*        larger distribution, in source or in binary form, PROVIDED        *
*        this notice is included with any such distribution, and is not    *
*        removed from any of its header files. Mention of ncurses in any   *
*        applications linked with it is highly appreciated.                *
*                                                                          *
*        ncurses comes AS IS with no warranty, implied or expressed.       *
*                                                                          *
***************************************************************************/



/*
**	lib_newterm.c
**
** 	The newterm() function.
**
*/

#include <curses.priv.h>

#ifdef SVR4_TERMIO
#define _POSIX_SOURCE
#endif

#include "term.h"	/* clear_screen, cup & friends, cur_term */

/* This should moved to TERMINAL */
static filter_mode = FALSE;

void filter(void)
{
    filter_mode = TRUE;
}

SCREEN * newterm(const char *term, FILE *ofp, FILE *ifp)
{
int	errret;
#ifdef TRACE
char *t = getenv("NCURSES_TRACE");

	if (t)
               trace((unsigned) strtol(t, 0, 0));
#endif

	T(("newterm(\"%s\",%p,%p) called", term, ofp, ifp));

	/* this loads the capability entry, then sets LINES and COLS */
	if (setupterm(term, fileno(ofp), &errret) == ERR)
	    	return NULL;

	/*
	 * Check for mismatched graphic-rendition capabilities.  Most svr4
	 * terminfo tree contain entries that have rmul or rmso equated to sgr0
	 * (Solaris curses copes with those entries).  We do this only for
	 * curses, since many termcap applications assume that smso/rmso and
	 * smul/rmul are paired, and will not function properly if we remove
	 * rmso or rmul.  Curses applications shouldn't be looking at this
	 * detail.
	 */
	if (exit_attribute_mode) {
#define SGR0_FIX(mode) if (mode != 0 && !strcmp(mode, exit_attribute_mode)) \
			mode = 0
		SGR0_FIX(exit_underline_mode);
		SGR0_FIX(exit_standout_mode);
	}

	/* optional optimization hack -- do before any output to ofp */
#if HAVE_SETVBUF || HAVE_SETBUFFER
	{
	  /*
	   * If the output file descriptor is connected to a tty
	   * (the typical case) it will probably be line-buffered.
	   * Keith Bostic pointed out that we don't want this; it
	   * hoses people running over networks by forcing out a
	   * bunch of small packets instead of one big one, so
	   * screen updates on ptys look jerky.  Restore block
	   * buffering to prevent this minor lossage.
	   *
	   * The buffer size is a compromise.  Ideally we'd like a
	   * buffer that can hold the maximum possible update size
	   * (the whole screen plus cup commands to change lines as
	   * it's painted).  On a modern 66-line xterm this can
	   * become excessive.  So we min it with the amount of data
	   * we think we can get through two Ethernet packets
	   * (maximum packet size - 100 for TCP/IP overhead).
	   *
	   * Why two ethernet packets?  It used to be one, on the theory
	   * that said packets define the maximum size of atomic update.
	   * But that's less than the 2000 chars on a 25 x 80 screen, and
	   * we don't want local updates to flicker either.  Two packet
	   * lengths will handle up to a 35 x 80 screen.
	   *
	   * The magic '6' is the estimated length of the end-of-line
	   * cup sequence to go to the next line.  It's generous.  We
	   * used to mess with the buffering in init_mvcur() after cost
	   * computation, but that lost the sequences emitted by init_acs()
	   * in setupscreen().
	   *
	   * "The setvbuf function may be used only after the stream pointed
	   * to by stream as been associated with an open file and before any
	   * other operation is performed on the stream." (ISO 7.9.5.6.)
	   *
	   * Grrrr...
	   */
	  unsigned int bufsiz = min(LINES * (COLS + 6), 2800);

#if HAVE_SETVBUF
#ifdef SETVBUF_REVERSED	/* pre-svr3? */
	  (void) setvbuf(ofp, malloc(bufsiz), bufsiz, _IOFBF);
#else
	  (void) setvbuf(ofp, malloc(bufsiz), _IOFBF, bufsiz);
#endif
#elif HAVE_SETBUFFER
	  (void) setbuffer(ofp, malloc(bufsiz), (int)bufsiz);
#endif
	}
#endif /* HAVE_SETVBUF || HAVE_SETBUFFER */

	/* implement filter mode */
	if (filter_mode) {
	    LINES = 1;

#ifdef init_tabs
	if (init_tabs != -1)
		TABSIZE = init_tabs;
	else
#endif /* init_tabs */
		TABSIZE = 8;

	T(("TABSIZE = %d", TABSIZE));

#ifdef clear_screen
	    clear_screen = (char *)NULL;
	    cursor_down = parm_down_cursor = (char *)NULL;
	    cursor_address = (char *)NULL;
	    cursor_up = parm_up_cursor = (char *)NULL;
	    row_address = (char *)NULL;

	    cursor_home = carriage_return;
#endif /* clear_screen */
	}

	/* If we must simulate soft labels, grab off the line to be used.
	   We assume that we must simulate, if it is none of the standard
	   formats (4-4  or 3-2-3) for which there may be some hardware
	   support. */
#ifdef num_labels
	if (num_labels <= 0 || !SLK_STDFMT)
#endif /* num_labels */
	    if (_nc_slk_format)
	      {
		if (ERR==_nc_ripoffline(-SLK_LINES, _nc_slk_initialize))
		  return NULL;
	      }
	/* this actually allocates the screen structure */
	if (_nc_setupscreen(LINES, COLS, ofp) == ERR)
	    	return NULL;

#ifdef num_labels
	/* if the terminal type has real soft labels, set those up */
	if (_nc_slk_format && num_labels > 0 && SLK_STDFMT)
	    _nc_slk_initialize(stdscr, COLS);
#endif /* num_labels */

	SP->_ifd        = fileno(ifp);
	SP->_checkfd	= fileno(ifp);
	typeahead(fileno(ifp));
#ifdef TERMIOS
	SP->_use_meta   = ((cur_term->Ottyb.c_cflag & CSIZE) == CS8 &&
			    !(cur_term->Ottyb.c_iflag & ISTRIP));
#else
	SP->_use_meta   = FALSE;
#endif
	SP->_endwin	= FALSE;

	baudrate();	/* sets a field in the SP structure */

	/* compute movement costs so we can do better move optimization */
	_nc_mvcur_init();

#if 0
	/* initialize soft labels */
	if (_nc_slk_format)
	    if (num_labels <= 0)
		_nc_ripoffline(-SLK_LINES, _nc_slk_initialize);
	    else
		_nc_slk_initialize(stdscr, COLS);
#endif
	_nc_signal_handler(TRUE);

	/* open a connection to the screen's associated mouse, if any */
	_nc_mouse_init(SP);

	T(("newterm returns %p", SP));

	return(SP);
}

