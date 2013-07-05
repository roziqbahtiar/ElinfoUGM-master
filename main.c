/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/30/2013
Author  : Ardika
Company : CrowjaEmbedder
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <alcd.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x60

// definisi tombol-tombol
#define CMD_UP          PINC.4
#define CMD_DOWN        PINC.5
#define CMD_OK          PINC.6
#define CMD_CANCEL      PINC.7
#define ANY_KEY_PRESSED (PINC & 0xF0) 

// Detektor persimpangan jalan
#define RIGHT_WING  PIND.0
#define LEFT_WING   PIND.1

// definisi kendali motor
#define RIGHT_PWM   OCR1AL
#define LEFT_PWM    OCR1BL
#define TOP_PWM     255
#define BOTTOM_PWM  0
#define RIGHT_DR1   PORTD.6
#define RIGHT_DR2   PORTD.7
#define LEFT_DR1    PORTD.2
#define LEFT_DR2    PORTD.3 

// definisi custom character LCD
#define FULL_BLOCK  0
#define EMPTY_BLOCK 1
#define LEFT_HORN   2
#define RIGHT_HORN  3
#define LEFT_ARROW  4
#define RIGHT_ARROW 5

// definisi untuk melakukan kalibrasi
#define CALIBRATING_COUNT   100

// Permodelan menu menggunakan linked list
struct menu {
    char text[16];
    struct menu *prev;
    struct menu *next;
    struct menu *child;
    void (*onExecute)();
};

typedef struct menu Menu;

//flash Menu start = {"Mulai",,,NULL,};



flash unsigned char fullBlock[8] = {
    0b11111,
    0b11111,
    0b11111,
    0b11111,
    0b11111,
    0b11111,
    0b11111,
    0b11111
};   
                                    
flash unsigned char emptyBlock[8] = {
    0b11111,
    0b10001,
    0b10001,
    0b10001,
    0b10001,
    0b10001,
    0b10001,
    0b11111
};
  
flash unsigned char leftHorn[8] = {
	0b10000,
	0b11000,
	0b11100,
	0b11111,
	0b11111,
	0b01111,
	0b00111,
	0b00011
};

flash unsigned char  rightHorn[8] = {
	0b00001,
	0b00011,
	0b01111,
	0b11111,
	0b11111,
	0b11110,
	0b11100,
	0b11000
};

flash unsigned char leftArrow[8] = {
	0b00001,
	0b00111,
	0b01111,
	0b11111,
	0b11111,
	0b01111,
	0b00111,
	0b00001
};

flash unsigned char  rightArrow[8] = {
	0b10000,
	0b11100,
	0b11110,
	0b11111,
	0b11111,
	0b11110,
	0b11100,
	0b10000
};



// Variabel-variabel kontrol yang tersimpan di memory non-volatile
eeprom unsigned char eeMaxSpeed = 255;
eeprom unsigned char eeMinSpeed = 0;
eeprom int eeKp = 125;
eeprom float eeKd = 0.0f;
eeprom float eeKi = 0.3f;

// Varibel kepekaan sensor dalam memory non-volaitile
eeprom unsigned char eeWhiteMin[8] = {5,5,5,5,5,5,5,5};   // Nilai pembacaan minimal untuk putih
eeprom unsigned char eeBlackMax[8] = {230,230,230,230,230,230,230,230};  // Nilai pembacaan maksimal untuk hitam
eeprom unsigned char eeMiddleVal[8] = {120,120,120,120,120,120,120,120};   // Nilai tengah antara white min dan black max

// Varibael-varibel kontrol yang disimpan di memory volatile untuk perhitungan kontrol
unsigned char maxSpeed = 255;     // nilai kecepatan maksimal
unsigned char minSpeed = 0;
unsigned char speedStep = 0;

int kp = 0;           // konstanta proposional
float kd = 1.0f;           // konstanta derivatif
float ki = 1.0f;           // konstanta integral
int error = 0;        // nilai error pembacaan sensor saat ini
int errorDiff = 0;    // selisih error dan error sebelumnya 
int lastError = 0;    // nilai error sebelumnya
int propotional = 0;
int integral = 0;
float derivative = 0;


int sp;           // nilai set point sensor 
int currentPosition;
int targetPosition = 0;
int integral;
//int derivative;
int previousError = 0;
int dt = 1;
int output = 0;


// Variabel kepekaan sensor dalam memory volatile untuk perhitungan
unsigned char whiteMin[8] = {0};   // Nilai pembacaan minimal untuk putih
unsigned char blackMax[8] = {0};  // Nilai pembacaan maksimal untuk hitam
unsigned char middleVal[8] = {0};   // Nilai tengah antara white min dan black max

// Varibel penyimpan nilai sensor biner, dimana tiap satu sensor nilainya diwakili oleh 1-bit
// yang merupakan hasil perbandingan pembacaan nilai analog sensor dengan nilai kepekaan sensor
unsigned char sensor = 0;
// Flag yang menandakan warna garis saat ini, 0: hitam, 1: putih
bit lineColorFlag = 0;

//prototype fungsi
void define_char(unsigned char flash *pc,unsigned char char_code);
unsigned char read_adc(unsigned char adc_input);
void scanLineRelative();
void scanLineActual();
void loadVariables();
void saveVariables();
void lcdOn(unsigned char on);
void lcdOnWing();
void go();
void back();
void left();
void right();
void stop(unsigned char usingPowerBrake);
void lcdPrintByte(unsigned char value);
void printADCSensor();
void printBinarySensor();
void whiteCalibrating();
void blackCalibrating();
void applyCalibratedValue();
void pid();
void showStartup();
void LCDInit();   
void myPID();


void main(void)
{

    PORTA=0x00;
    DDRA=0x00;

    PORTB=0xFF;
    DDRB=0xFF;
     
    PORTC=0x00;
    DDRC=0x00;

    PORTD=0x00;
    DDRD=0xFC;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 250.000 kHz
    // Mode: Fast PWM top=0x00FF
    // OC1A output: Non-Inv.
    // OC1B output: Non-Inv.
    TCCR1A=0xA1;
    TCCR1B=0x0B;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // ADC initialization
    // ADC Clock frequency: 125.000 kHz
    // ADC Voltage Reference: AVCC pin
    // Only the 8 most significant bits of
    // the AD conversion result are used
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x87;

    LCDInit();
    
    loadVariables();    
    applyCalibratedValue();
    
    //showStartup(); 
    go();       

    while (1) {     
        //lcd_gotoxy(0,0);
        //scanLineActual();
        //scanLineRelative();
        scanLineActual();
        myPID();
        //printBinarySensor();     
        //printADCSensor();  
        
              
    }
}


/* function used to define user characters */
void define_char(unsigned char flash *pc,unsigned char char_code)
{
    unsigned char i,a;
    a=(char_code<<3) | 0x40;
    for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}


// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
    // Delay needed for the stabilization of the ADC input voltage
    //delay_us(10);
    // Start the AD conversion
    ADCSRA|=0x40;
    // Wait for the AD conversion to complete
    while (!(ADCSRA & 0x10));
        ADCSRA |= 0x10;
    return ADCH;
}

// Fungsi scan garis aktual dimana nilai pembacaan hitam adalah 1 dan nilai pembacaan putih adalah 0
void scanLineActual()
{
    unsigned char i = 8;    
    unsigned char adcRead;   
    
    sensor = 0;   // reset nilai sensor    
    while (i--) {
        adcRead = read_adc(i);  // Baca nilai ADC ada bit ke-i  
        if (adcRead > middleVal[i]) 
            sensor |= (1<<i);     
    }                               
    lineColorFlag = 0;   // pada pembacaan aktual, sayap persimpangan mengangsumsikan garis adalah hitam
}


// Fungsi scan garis relatif dimana garis dibaca secara relatif terhadap perbandingan antara blok hitam dan putih yang terbaca
// jika blok putih > blok hitam maka garis adalah hitam, sebaihnya garis adalah putih. Garis tetap dibaca sebagai bit set/1 
void scanLineRelative()
{
    unsigned char i = 8;      
    unsigned char adcRead;  // Variabel pembacaan nilai ADC          
    // JUmlah warna hitam yang terdeteksi oleh sensor
    unsigned char blackCount = 0;             
   
    sensor = 0x00;   // Hapus nilai sensor sebelumnya
    while (i--) {
        adcRead = read_adc(i);  // Baca nilai ADC ada bit ke-i  
        if (adcRead > middleVal[i]) {
            blackCount++;       // Increment jumlah blok hitam yang terbaca
            sensor |= (1<<i);
        }     
    }                  
    if (blackCount >= 4) {   // Jika blok hitam yg terdeteksi banyak, maka garisnya adalah putih
        sensor = ~sensor;
        lineColorFlag = 1;
    }                     
    else
        lineColorFlag = 0;
}

void loadVariables()
{
    unsigned char i = 0;  
    eeprom int *ptr;  
    eeprom unsigned char *ptr1;
    eeprom float *ptr2;
                 
    ptr1 = &eeMaxSpeed;
    maxSpeed = *ptr1;
    ptr1 = &eeMinSpeed;
    minSpeed = *ptr1;
    speedStep = (maxSpeed - minSpeed) / 8;
      
    ptr = &eeKp;
    kp = *ptr;
    ptr2 = &eeKd;
    kd = *ptr2;
    ptr2 = &eeKi;
    ki = *ptr2;
    
    for (; i<8; i++) {        
        ptr1 = &eeWhiteMin[i];
        whiteMin[i] = *ptr1;
        ptr1 = &eeBlackMax[i];
        blackMax[i] = *ptr1;
    }    
}

void saveVariables()
{
    unsigned char i = 0;  
    eeprom int *ptr;  
    eeprom unsigned char *ptr1; 
    eeprom float *ptr2;
             
    ptr1 = &eeMaxSpeed;
    *ptr1 = maxSpeed;  
    ptr1 = &eeMinSpeed;
    *ptr1 = minSpeed;
    ptr = &eeKp;
    *ptr = kp;
    ptr2 = &eeKd;
    *ptr2 = kd;
    ptr2 = &eeKi;
    *ptr2 = ki;
    
    for (; i<8; i++) {   
        ptr1 = &eeWhiteMin[i];
        *ptr1 = whiteMin[i];
        ptr1 = &eeBlackMax[i];
        *ptr1 = blackMax[i];
    }
}


void lcdOn(unsigned char on)
{
    PORTB.3 = on;
}

void lcdOnWing()
{
    PORTB.3 = !((LEFT_WING) | (RIGHT_WING));
}

void go()
{
    RIGHT_DR1 = 0; RIGHT_DR2 = 1;
    LEFT_DR1 = 0; LEFT_DR2 = 1; 
}

void back()
{
    RIGHT_DR1 = 1; RIGHT_DR2 = 0;
    LEFT_DR1 = 1; LEFT_DR2 = 0;        
}

void left()
{
    RIGHT_DR1 = 0; RIGHT_DR2 = 1;
    LEFT_DR1 = 0; LEFT_DR2 = 0;
}

void right()
{
    RIGHT_DR1 = 0; RIGHT_DR2 = 0;
    LEFT_DR1 = 0; LEFT_DR2 = 1;
}

void stop(unsigned char usingPowerBrake)
{
    RIGHT_DR1 = RIGHT_DR2 = LEFT_DR1 = LEFT_DR2 = 0;
    if (usingPowerBrake) {
        back();
        LEFT_PWM = RIGHT_PWM = 255;
        delay_ms(100);
        LEFT_PWM = RIGHT_PWM = 0;
    }     
    
}

void lcdPrintByte(unsigned char value)
{
    unsigned char ten = (value % 100) / 10;
    lcd_putchar('0' + (value / 100));  
    lcd_putchar('0' + ten);
    lcd_putchar('0' + (value % 10));
}

void printADCSensor()
{
    lcd_gotoxy(0,0); lcdPrintByte(read_adc(0));
    lcd_gotoxy(4,0); lcdPrintByte(read_adc(1));
    lcd_gotoxy(8,0); lcdPrintByte(read_adc(2));
    lcd_gotoxy(12,0); lcdPrintByte(read_adc(3));
    lcd_gotoxy(0,1); lcdPrintByte(read_adc(4));
    lcd_gotoxy(4,1); lcdPrintByte(read_adc(5));
    lcd_gotoxy(8,1); lcdPrintByte(read_adc(6));
    lcd_gotoxy(12,1); lcdPrintByte(read_adc(7)); 
}

void printBinarySensor()
{
    unsigned char i = 0;
    
    for (; i<8; i++) {
        if (sensor & (1<<i))
            lcd_putchar(FULL_BLOCK);
        else
            lcd_putchar(EMPTY_BLOCK);
    }
}  


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// REGION CALIBRATING FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    PROSEDUR MELAKUKAN KALIBRASI:
        Panggil kedua fungsi blackCalibrating() dan whiteCalibrating()
        Panggil fungsi applyCalibratedValue()
*/

void blackCalibrating()
{
    unsigned char i;
    unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor    
    unsigned char calibratedBlackMax;  // Nilai hitam maksimal hasil kalibrasi hitam, untuk tiap sensor     
    unsigned char readADC;  // nilai pembacaan ADC 
                         
    // Kalibrasi HItam
    for (i=0; i<8; i++) {    
        calibratingCount = CALIBRATING_COUNT;
        calibratedBlackMax = 0;     // Atur nilainya menjadi nilai minimal tipedata unsigned byte, karena kita akan mencari nilai maksimum
        while (calibratingCount--) {
            readADC = read_adc(i);
            if (readADC > calibratedBlackMax)
                calibratedBlackMax = readADC;        
        }                   
        blackMax[i] = eeBlackMax[i] = calibratedBlackMax;  // simpan nilai kalibarasi di ram sekaligus di eeprom
    } 
    
}

void whiteCalibrating()
{
    unsigned char i;
    unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor    
    unsigned char calibratedWhiteMin;  // Nilai hitam minimum hasil kalibrasi putih, untuk tiap sensor     
    unsigned char readADC;  // nilai pembacaan ADC  
                         
    // Kalibrasi HItam
    for (i=0; i<8; i++) {
        calibratingCount = CALIBRATING_COUNT;     
        calibratedWhiteMin = 255;     // Atur nilainya menjadi nilai maksimal tipedata unsigned byte, karena kita akan mencari nilai minimum
        while (calibratingCount--) {
            readADC = read_adc(i);
            if (readADC < calibratedWhiteMin)
                calibratedWhiteMin = readADC;        
        }                   
        whiteMin[i] = eeWhiteMin[i] = calibratedWhiteMin;  // simpan nilai kalibarasi di ram sekaligus di eeprom
    } 
}

void applyCalibratedValue()
{
    unsigned char i = 0;
    
    for (; i<8; i++) { 
        middleVal[i] = eeMiddleVal[i] = ((blackMax[i] - whiteMin[i]) / 2);   
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// END OF REGION CALIBRATING FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void showStartup()
{
    char str[12] = "\4BISMILLAH\5";
    char str1[17] = "ROBOTIKA UNNES ";
    unsigned char i = 0;
    
    lcd_gotoxy(3,0);
    for (; i<11; i++) {
        lcd_putchar(str[i]);
        delay_ms(100);
    }          
    lcd_gotoxy(1,1);
    for (i=0; i<15; i++) {
        lcd_putchar(str1[i]);
        delay_ms(100);
    }  
    delay_ms(2000);  
    lcd_clear();
}

void LCDInit()
{
    lcd_init(16);   
    lcd_clear();
    define_char(fullBlock,FULL_BLOCK);
    define_char(emptyBlock,EMPTY_BLOCK);  
    define_char(leftHorn,LEFT_HORN);
    define_char(rightHorn,RIGHT_HORN);
    define_char(leftArrow,LEFT_ARROW);
    define_char(rightArrow,RIGHT_ARROW);
    lcdOn(1);       
    lcd_clear();
}

unsigned char abs(int val)
{
    return ((val<0)?(-val):(val));
}

void myPID()
{
    int leftpwm,rightpwm;       
    int movement;
    
    switch (sensor) {
        case 0b00000001:
            error = 7;
            break; 
        case 0b00000011:
        case 0b00000111:
            error = 6;
            break;   
        case 0b00000010:
            error = 5;
            break;
        case 0b00000110:
        case 0b00001110:
            error = 4;
            break;    
        case 0b00000100:
            error = 3;
            break;
        case 0b00001100:
        case 0b00011100:
            error = 2;
            break;    
        case 0b00001000:
            error = 1;
            break;
        case 0b00011000:
            error = 0;
            break;
        case 0b00010000:
            error = -1;
            break;    
        case 0b00110000:
        case 0b00111000:
            error = -2;
            break;     
        case 0b00100000:
            error = -3;
        case 0b01100000:
        case 0b01110000:
            error = -4;
            break;     
        case 0b01000000:
            error = -5;
            break;
        case 0b11000000:
        case 0b11100000:
            error = -6;
            break;    
        case 0b10000000:
            error = -7;
            break;     
        case 0b00000000:
            if (error < 0) 
                error = -8;
            else if (error > 0)
                error = 8;
            break;
    }           
                        
    // hitung nilai unsur proposional
    propotional = kp * error;
    integral += (error);      
    integral =   ki* integral;
    derivative = (error - previousError);
      
   // movement = propotional;
    movement = propotional + integral;// + (kd * derivative);   
    previousError = error; 
    
    if (movement == 0) 
        leftpwm = rightpwm = maxSpeed;
    else if (movement > 0) {   // Ke kanan
        rightpwm = maxSpeed - (movement);//* 15 );//speedStep);
        leftpwm = maxSpeed + (movement);// * 15);//speedStep);//- 30;        
    } 
    else if (movement < 0) {
        leftpwm = maxSpeed + (movement);// *15);// speedStep);
        rightpwm = maxSpeed - (movement);// *15);// speedStep);//- 30;     
    } 
    if (leftpwm < minSpeed)
        leftpwm = minSpeed;
    if (leftpwm > maxSpeed)
        leftpwm = maxSpeed;
    if (rightpwm < minSpeed)
        rightpwm = minSpeed;
    if (rightpwm > maxSpeed)
        rightpwm = maxSpeed;                                                       
    
    LEFT_PWM = leftpwm;
    RIGHT_PWM = rightpwm;   
    
    lcd_gotoxy(0,0);
    lcdPrintByte(rightpwm);
    lcd_gotoxy(13,0);
    lcdPrintByte(leftpwm);  
    lcd_gotoxy(4,0);
    printBinarySensor();  
   
}

void pid()
{
    int errorA =0, errorB=0;
    switch(sensor) {
        case 0b00000000: 
            if(errorA >=0 && errorA <=5){
            }
            if(errorB >=0 && errorB <=5){
            }
            break;	
            case 0b00000001: errorA = 7;errorB = 0; lcd_putchar('L');break;	 
            case 0b00000011: errorA = 6;errorB = 0; break;
            case 0b00000010: errorA = 5;errorB = 0; break;
            case 0b00000110: errorA = 4;errorB = 0; break;
            case 0b00000100: errorA = 3;errorB = 0;break;
            case 0b00001100: errorA = 2;errorB = 0; break;
            case 0b00001000: errorA = 1;errorB = 0; break;         
            case 0b00011000: errorA = 0;errorB =0 ;break;
            case 0b00010000: errorA = 0;errorB = 1; break;
            case 0b00110000: errorA = 0;errorB = 2; break;
            case 0b00100000: errorA = 0;errorB = 3; break;
            case 0b01100000: errorA = 0;errorB = 4;break;
            case 0b01000000: errorA = 0;errorB = 5; break;
            case 0b11000000: errorA = 0;errorB = 6; break;
            case 0b10000000: errorA = 0;errorB = 7; break;       			
        }
        
      
      
      
   if(errorA == 0 && errorB == 0) currentPosition = 0;
        if(errorA >= 1 ) currentPosition = errorA;
        if(errorB >= 1 ) currentPosition = errorB;  
        
        error = targetPosition - currentPosition;
        output = 100 ;//( kp*error );
        
       /* integral = integral + (error*dt);
        derivative = ((error) - (previousError))/dt;
        output = (kp*error) + (ki*integral) + (kd*derivative);
        previousError = error;*/
         
                         
        if (output < 0 ){
        lcd_putchar('o'); 
        go(); 
        RIGHT_PWM = LEFT_PWM = 220;}
        if (output >0 && (errorA >=1 && errorA <=7)){lcd_putchar('L');go();RIGHT_PWM = 200 - output; LEFT_PWM = 0;} 
        if (output >0 && (errorB >=1 && errorB <=7)){lcd_putchar('R');go();LEFT_PWM = 10 - output; RIGHT_PWM = 200;}         
      //     if (output < 1 ){
      //  lcd_putchar('o'); 
       // left(); 
      //  RIGHT_PWM =200; LEFT_PWM = 40;}
     //   if (output >0 && (errorA >=1 && errorA <=7)){lcd_putchar('L');  left();RIGHT_PWM = maxSpeed - output; LEFT_PWM = maxSpeed;} 
    //    if (output >0 && (errorB >=1 && errorB <=7)){lcd_putchar('R'); left();LEFT_PWM = maxSpeed - output; RIGHT_PWM = maxSpeed;}  
     //      if (output > 0 ){
     //   lcd_putchar('o'); 
       // right(); 
      //  RIGHT_PWM =40; LEFT_PWM = 180;}
      //  if (output >0 && (errorA <=1 && errorA >=7)){lcd_putchar('L');right();RIGHT_PWM = maxSpeed - output; LEFT_PWM = maxSpeed;} 
      //  if (output >0 && (errorB <=1 && errorB >=7)){lcd_putchar('R');right();LEFT_PWM = maxSpeed - output; RIGHT_PWM = maxSpeed;}         
                              
                                      
        //delay_ms(dt); 
}

