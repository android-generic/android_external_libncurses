
/*
 * THIS CODE IS SPECIFICALLY EXEMPTED FROM THE NCURSES PACKAGE COPYRIGHT.
 * You may freely copy it for use as a template for your own field types.
 * If you develop a field type that might be of general use, please send
 * it back to the ncurses maintainers for inclusion in the next version.
 */
/***************************************************************************
*                                                                          *
*  Author : Juergen Pfeifer, Juergen.Pfeifer@T-Online.de                   *
*                                                                          *
***************************************************************************/

#include "form.priv.h"

MODULE_ID("$Id: fty_alnum.c,v 1.4 1996/11/19 15:23:53 juergen Exp $")

typedef struct {
  int width;
} alnumARG;

/*---------------------------------------------------------------------------
|   Facility      :  libnform  
|   Function      :  static void *Make_AlphaNumeric_Type(va_list *ap)
|   
|   Description   :  Allocate structure for alphanumeric type argument.
|
|   Return Values :  Pointer to argument structure or NULL on error
+--------------------------------------------------------------------------*/
static void *Make_AlphaNumeric_Type(va_list * ap)
{
  alnumARG *argp = (alnumARG *)malloc(sizeof(alnumARG));

  if (argp)
    argp->width = va_arg(*ap,int);

  return ((void *)argp);
}

/*---------------------------------------------------------------------------
|   Facility      :  libnform  
|   Function      :  static void *Copy_AlphaNumericType(const void *argp)
|   
|   Description   :  Copy structure for alphanumeric type argument.  
|
|   Return Values :  Pointer to argument structure or NULL on error.
+--------------------------------------------------------------------------*/
static void *Copy_AlphaNumeric_Type(const void *argp)
{
  alnumARG *ap  = (alnumARG *)argp;
  alnumARG *new = (alnumARG *)malloc(sizeof(alnumARG));

  if (new)
    *new = *ap;

  return ((void *)new);
}

/*---------------------------------------------------------------------------
|   Facility      :  libnform  
|   Function      :  static void Free_AlphaNumeric_Type(void *argp)
|   
|   Description   :  Free structure for alphanumeric type argument.
|
|   Return Values :  -
+--------------------------------------------------------------------------*/
static void Free_AlphaNumeric_Type(void * argp)
{
  if (argp) 
    free(argp);
}

/*---------------------------------------------------------------------------
|   Facility      :  libnform  
|   Function      :  static bool Check_AlphaNumeric_Field(
|                                      FIELD *field,
|                                      const void *argp)
|   
|   Description   :  Validate buffer content to be a valid alphanumeric value
|
|   Return Values :  TRUE  - field is valid
|                    FALSE - field is invalid
+--------------------------------------------------------------------------*/
static bool Check_AlphaNumeric_Field(FIELD * field, const void * argp)
{
  int width = ((alnumARG *)argp)->width;
  unsigned char *bp  = (unsigned char *)field_buffer(field,0);
  int  l = -1;
  unsigned char *s;

  while(*bp && *bp==' ') 
    bp++;
  if (*bp)
    {
      s = bp;
      while(*bp && isalnum(*bp)) 
	bp++;
      l = (int)(bp-s);
      while(*bp && *bp==' ') 
	bp++;
    }
  return ((*bp || (l < width)) ? FALSE : TRUE);
}

/*---------------------------------------------------------------------------
|   Facility      :  libnform  
|   Function      :  static bool Check_AlphaNumeric_Character(
|                                      int c, 
|                                      const void *argp )
|   
|   Description   :  Check a character for the alphanumeric type.
|
|   Return Values :  TRUE  - character is valid
|                    FALSE - character is invalid
+--------------------------------------------------------------------------*/
static bool Check_AlphaNumeric_Character(int c, const void * argp)
{
  return (isalnum(c) ? TRUE : FALSE);
}

static FIELDTYPE typeALNUM = {
  _HAS_ARGS | _RESIDENT,
  1,                           /* this is mutable, so we can't be const */
  (FIELDTYPE *)0,
  (FIELDTYPE *)0,
  Make_AlphaNumeric_Type,
  Copy_AlphaNumeric_Type,
  Free_AlphaNumeric_Type,
  Check_AlphaNumeric_Field,
  Check_AlphaNumeric_Character,
  NULL,
  NULL
};

FIELDTYPE* TYPE_ALNUM = &typeALNUM;

/* fty_alnum.c ends here */
