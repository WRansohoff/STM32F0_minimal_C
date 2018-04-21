/*
 * Test program to boot an STM32 chip with the absolute
 * minimum required code for teaching about the chips.
 *
 * Copyright William Ransohoff, Vivonomicon, LLC, 2017
 *
 * Open source under the MIT License
 */

.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

.global vtable
.global default_interrupt_handler

/*
 * The vector table.
 */
.type vtable, %object
.section .vector_table,"a",%progbits
vtable:
    .word _estack
    .word reset_handler
    .word NMI_handler
    .word hard_fault_handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_handler
    .word 0
    .word 0
    .word pending_SV_handler
    .word SysTick_handler
    // 16-31
    .word window_watchdog_IRQ_handler
    .word PVD_IRQ_handler
    .word RTC_IRQ_handler
    .word flash_IRQ_handler
    .word RCC_IRQ_handler
    .word EXTI0_1_IRQ_handler
    .word EXTI2_3_IRQ_handler
    .word EXTI4_15_IRQ_handler
    .word 0
    .word DMA1_chan1_IRQ_handler
    .word DMA1_chan2_3_IRQ_handler
    .word DMA1_chan4_5_IRQ_handler
    .word ADC1_IRQ_handler
    .word TIM1_break_IRQ_handler
    .word TIM1_CC_IRQ_handler
    .word TIM2_IRQ_handler
    // 32-47
    .word TIM3_IRQ_handler
    .word 0
    .word 0
    .word TIM14_IRQ_handler
    .word 0
    .word TIM16_IRQ_handler
    .word TIM17_IRQ_handler
    .word I2C1_IRQ_handler
    .word 0
    .word SPI1_IRQ_handler
    .word 0
    .word USART1_IRQ_handler
    .word 0
    .word 0
    .word 0
    .word 0
    // 48
    // (Location to boot from for RAM startup)
    #define boot_ram_base  0xF108F85F
    .word boot_ram_base

    /*
     * Setup weak aliases for each exception handler to the
     * default one. These can be updated later, or just
     * overridden since they're weak refs.
     * The reset_handler is set up separately.
     */
    .weak NMI_handler
    .thumb_set NMI_handler,default_interrupt_handler
    .weak hard_fault_handler
    .thumb_set hard_fault_handler,default_interrupt_handler
    .weak SVC_handler
    .thumb_set SVC_handler,default_interrupt_handler
    .weak pending_SV_handler
    .thumb_set pending_SV_handler,default_interrupt_handler
    .weak SysTick_handler
    .thumb_set SysTick_handler,default_interrupt_handler
    .weak window_watchdog_IRQ_handler
    .thumb_set window_watchdog_IRQ_handler,default_interrupt_handler
    .weak PVD_IRQ_handler
    .thumb_set PVD_IRQ_handler,default_interrupt_handler
    .weak RTC_IRQ_handler
    .thumb_set RTC_IRQ_handler,default_interrupt_handler
    .weak flash_IRQ_handler
    .thumb_set flash_IRQ_handler,default_interrupt_handler
    .weak RCC_IRQ_handler
    .thumb_set RCC_IRQ_handler,default_interrupt_handler
    .weak EXTI0_1_IRQ_handler
    .thumb_set EXTI0_1_IRQ_handler,default_interrupt_handler
    .weak EXTI2_3_IRQ_handler
    .thumb_set EXTI2_3_IRQ_handler,default_interrupt_handler
    .weak EXTI4_15_IRQ_handler
    .thumb_set EXTI4_15_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan1_IRQ_handler
    .thumb_set DMA1_chan1_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan2_3_IRQ_handler
    .thumb_set DMA1_chan2_3_IRQ_handler,default_interrupt_handler
    .weak DMA1_chan4_5_IRQ_handler
    .thumb_set DMA1_chan4_5_IRQ_handler,default_interrupt_handler
    .weak ADC1_IRQ_handler
    .thumb_set ADC1_IRQ_handler,default_interrupt_handler
    .weak TIM1_break_IRQ_handler
    .thumb_set TIM1_break_IRQ_handler,default_interrupt_handler
    .weak TIM1_CC_IRQ_handler
    .thumb_set TIM1_CC_IRQ_handler,default_interrupt_handler
    .weak TIM2_IRQ_handler
    .thumb_set TIM2_IRQ_handler,default_interrupt_handler
    .weak TIM3_IRQ_handler
    .thumb_set TIM3_IRQ_handler,default_interrupt_handler
    .weak TIM14_IRQ_handler
    .thumb_set TIM14_IRQ_handler,default_interrupt_handler
    .weak TIM16_IRQ_handler
    .thumb_set TIM16_IRQ_handler,default_interrupt_handler
    .weak TIM17_IRQ_handler
    .thumb_set TIM17_IRQ_handler,default_interrupt_handler
    .weak I2C1_IRQ_handler
    .thumb_set I2C1_IRQ_handler,default_interrupt_handler
    .weak SPI1_IRQ_handler
    .thumb_set SPI1_IRQ_handler,default_interrupt_handler
    .weak USART1_IRQ_handler
    .thumb_set USART1_IRQ_handler,default_interrupt_handler
.size vtable, .-vtable

/*
 * A 'Default' interrupt handler. This is where interrupts
 * which are not otherwise configured will go.
 * It is an infinite loop, because...well, we weren't
 * expecting the interrupt, so what can we do?
 */
.section .text.default_interrupt_handler,"ax",%progbits
default_interrupt_handler:
    default_interrupt_loop:
      B default_interrupt_loop
.size default_interrupt_handler, .-default_interrupt_handler
