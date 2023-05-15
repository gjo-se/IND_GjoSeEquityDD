/*

   IND_GjoSeEquityDD.mq5
   Copyright 2021, Gregory Jo
   https://www.gjo-se.com

   Version History
   ===============

   1.0.0 Initial version

   ===============

//*/

#include <Mql5Book\MoneyManagement.mqh>
#include <GjoSe\\Objects\\InclVLine.mqh>

#property   copyright   "2021, GjoSe"
#property   link        "http://www.gjo-se.com"
#property   description "GjoSe EquityDD"
#define     VERSION "1.0.0"
#property   version VERSION
#property   strict

#property indicator_separate_window

#property indicator_buffers   2
#property indicator_plots     2

#property indicator_type1     DRAW_LINE
#property indicator_color1    clrBlack
#property indicator_width1    2
#property indicator_label1  "EquityDD"

#property indicator_type2     DRAW_LINE
#property indicator_color2    clrRed
#property indicator_width2    2
#property indicator_label2  "EquityDD-Dynamic"

#property indicator_minimum 0
#property indicator_maximum 60

input double InpMaxEquityDD = 20;
input double InpMaxEquityDD_OutAndStop = 30;

double EquityDDBuffer[];
double EquityDDDynamicBuffer[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit() {
   SetIndexBuffer(0, EquityDDBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, EquityDDDynamicBuffer, INDICATOR_DATA);

   PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, 0);

   IndicatorSetInteger(INDICATOR_LEVELS,2);
   IndicatorSetInteger(INDICATOR_LEVELCOLOR, clrRed);

   IndicatorSetDouble(INDICATOR_LEVELVALUE, 0, InpMaxEquityDD);
   IndicatorSetString(INDICATOR_LEVELTEXT, 0, NormalizeDouble(DoubleToString(InpMaxEquityDD), 2) + "% EquityDD");
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 1, InpMaxEquityDD_OutAndStop);
   IndicatorSetString(INDICATOR_LEVELTEXT, 1, NormalizeDouble(DoubleToString(InpMaxEquityDD_OutAndStop), 2) + "% Equity DD");

   string short_name = "EquityDD";
   IndicatorSetString(INDICATOR_SHORTNAME, short_name);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int pRatesTotal,
                const int pPrevCalculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]         ) {

   int         start, i;
   if(pPrevCalculated == 0) {
      start = 0;
   } else {
      start = pPrevCalculated - 1;
   }

   for(i = start; i < pRatesTotal && !IsStopped(); i++) {
      EquityDDBuffer[i] = getRelativeEquityDD(EQUITY_DD_PERCENT);

      if(i > 1) {
      EquityDDDynamicBuffer[i] = EquityDDBuffer[i] - EquityDDBuffer[i - 1];
//         if(EquityDDBuffer[i - 2] < InpMaxEquityDD && EquityDDBuffer[i - 1] > InpMaxEquityDD) {
//            //createVLine(__FUNCTION__ + IntegerToString(time[i - 1]), time[i - 1], clrGreen, 2);
//         }
      }


//                     if(ColorBuffer[pBarShift - 1] == 0 && ColorBuffer[pBarShift] == 2) {
//                        createVLine(__FUNCTION__ + IntegerToString(pTime[pBarShift]), pTime[pBarShift], clrRed, 2);
//                     }
//                     if(ColorBuffer[pBarShift - 1] == 2 && ColorBuffer[pBarShift] == 0) {
//                        createVLine(__FUNCTION__ + IntegerToString(pTime[pBarShift]), pTime[pBarShift], clrBlack);
//                     }
//                  }

   }


   return(pRatesTotal);
}
//+------------------------------------------------------------------+
