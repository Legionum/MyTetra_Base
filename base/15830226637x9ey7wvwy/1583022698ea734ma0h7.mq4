//+------------------------------------------------------------------+
//|                                                     Test_Bot.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


input  double trend = 0.001;
int intBars;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
                                            {                                          
                                            return;  
                                            }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
                  {
                  
                  bool New_Bar=False;
                  
                  if (f_IsNewBar())
                                         {
                                          bool Trend_direct = trend_function(trend);
                                          double hod_today_ =  hod_(Symbol(),PERIOD_D1,0);
                                          double hod_prev = hod_(Symbol(),PERIOD_D1,1);
                                          Order_Send(hod_today_, hod_prev, Trend_direct);
                                         }
                  
                  
                  }
//+------------------------------------------------------------------+

bool f_IsNewBar()
{
if(intBars != Bars)
                        {
                        intBars = Bars;
                        return(true);
                        }
return(false);
}

double hod_(string Symbol_name, string Period_,int shift)
                                                                     {
                                                                     double hod=0;
                                                                     
                                                                     hod =iHigh(Symbol_name,Period_,shift)-iLow(Symbol_name,Period_,1);
                                                                     
                                                                     hod = NormalizeDouble(hod,4);
                                                                     
                                                                     return hod;
                                                                     }

               
double hod(string Symbol_name)
                                             {
                                            
                                             double hod=0;
                                             hod =iHigh(Symbol_name,PERIOD_D1,1)-iLow(Symbol_name,PERIOD_D1,1);
                                             
                                             hod = NormalizeDouble(hod,4);
                                                         
                                             return hod;
                                             }
            
double hod_today(string Symbol_name)
                                             {
                                            
                                             double hod=0;
                                             hod =iHigh(Symbol_name,PERIOD_D1,0)-iLow(Symbol_name,PERIOD_D1,0);
                                             hod = NormalizeDouble(hod,4);
                                                         
                                             return hod;
                                             }
                                             
                                             
                                             
                                             
void Order_Send(double hod_today_, double hod_, bool Trend_direct)
                        {
                        if (hod_today_ > hod_)
                                                {
                                                if (Trend_direct == 1)
                                                                              {
                                                                              if (OrdersTotal()==1)
                                                                                                         {
                                                                                                         for(int i=OrdersTotal()-1;i>=0;i--)
                                                                                                                                                       {
                                                                                                                                                       OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
                                                                                                                                                        //if(OrderType()==OP_BUY)OrderClose(OrderTicket(),OrderLots(),Bid,slippage,0);
                                                                                                                                                        if(OrderType()==OP_SELL)OrderClose(OrderTicket(),OrderLots(),Ask,slippage,0);
                                                                                                                                                       }
                                                                                                         }
                                                                              if (OrdersTotal()<1)
                                                                                                         {
                                                                                                         OrderSend(Symbol(),OP_BUY,0.1,Ask,3,0,0);
                                                                                                         }
                                                                              
                                                                              }
                                                
                                                if (Trend_direct == 0)
                                                                              {
                                                                              if (OrdersTotal()==1)
                                                                                                         {
                                                                                                         for(int i=OrdersTotal()-1;i>=0;i--)
                                                                                                                                                       {
                                                                                                                                                       OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
                                                                                                                                                       if(OrderType()==OP_BUY)OrderClose(OrderTicket(),OrderLots(),Bid,slippage,0);
                                                                                                                                                        //if(OrderType()==OP_SELL)OrderClose(OrderTicket(),OrderLots(),Ask,slippage,0);
                                                                                                                                                       }
                                                                                                         }
                                                                              if (OrdersTotal()<1)
                                                                                                         {
                                                                                                         OrderSend(Symbol(),OP_SELL,0.1,Bid,3,0,0);
                                                                                                         }
                                                                              }
                                                }
                        
                        
                        
                        
                        }
                        
                        
extern int slippage=1000;


bool trend_function(double trend)
               {
               
               double MA1[10];
            
              
               bool trend_direction = 0;
            
           
               for (int i = 0; i<10;i++)
                                             {
                                             MA1[i] = NULL;
                                             MA1[i] =  iMA(Symbol(),PERIOD_D1,2,0,MODE_SMA, PRICE_MEDIAN,i);
                                             
                                             //Print("Значение средней ", MA1[i]);
                                             }
               
               double massiv[10];
               
               for (int i = 0; i<9;i++)
                                             {
                                             massiv[i]=NULL;
                                             massiv[i]=NormalizeDouble(MA1[i]-MA1[i+1],4);
                                             
                                             Print("Вычисление разницы     ",massiv[i]);
                                             }
               
               //определение тренда
               
               
               for (int i = 0; i<9;i++)
                                             {
                                             
                                             if (massiv[i] >0) 
                                                                           {
                                                                           if (MathAbs(massiv[i])>trend) trend_direction = 1;
                                                                           
                                                                           
                                                                           //Print("Восходящий тренд   ",massiv[i]);
                                                                           break;
                                                                           }
                                             if (massiv[i] < 0)
                                                                           {
                                                                           if (MathAbs(massiv[i])>trend) trend_direction = 0;

                                                                           //Print("Нисходящий тренд   ",massiv[i]);
                                                                           break;
                                                                           }
                                                                             
                                             }
               if (trend_direction == 1) Print("Восходящий тренд");
               else Print("Нисходящий тренд");
               return trend_direction;
               }