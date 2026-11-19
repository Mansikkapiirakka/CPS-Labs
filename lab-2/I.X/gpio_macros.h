
/* :D */ 
#ifndef GPIO_MACROS_H
#define GPIO_MACROS_H

#define BIT(n)				(1U << (n))
#define SET_BIT(reg, n)		((reg) |= (BIT(n)))
#define CLR_BIT(reg, n)		((reg) &= ~BIT(n))
#define TOG_BIT(reg, n)		((reg) ^= BIT(n))
#define BIT_IS_SET(reg,n)   ((reg) & BIT(n))

#endif /* GPIO_MACROS_H */

