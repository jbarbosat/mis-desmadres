 register /home/pandora/hadoop-stack/pig-0.11.0/contrib/piggybank/java/piggybank.jar;    
define replace org.apache.pig.piggybank.evaluation.string.REPLACE;  
define substring org.apache.pig.piggybank.evaluation.string.SUBSTRING;  
 define s_split org.apache.pig.piggybank.evaluation.string.Split;
 define reverse org.apache.pig.piggybank.evaluation.string.Reverse; 

 dirtyrita = LOAD 'rita878889/878889.csv' USING PigStorage(',') AS 
    (Year:chararray, Month:chararray, DayofMonth:chararray, DayOfWeek:chararray,
     DepTime:chararray, CRSDepTime:chararray, ArrTime:chararray, CRSArrTime:chararray,
     UniqueCarrier:chararray, FlightNum:chararray, TailNum:chararray, ActualElapsedTime:chararray,
     CRSElapsedTime:chararray, AirTime:chararray, ArrDelay:chararray, DepDelay:chararray,
     Origin:chararray, Dest:chararray, Distance:chararray, TaxiIn:chararray, TaxiOut:chararray,
     Cancelled:chararray, CancellationCode:chararray, Diverted:chararray, CarrierDelay:chararray,
     WeatherDelay:chararray, NASDelay:chararray, SecurityDelay:chararray, LateAircraftDelay:chararray);

rita0 = foreach dirtyrita generate $0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,
        replace(Month, 'NA', '00') as Month2, 
        replace(DayofMonth, 'NA', '00') as DayofMonth2,
        replace(DepTime, 'NA', '000') as DepTime2,
        replace(CRSDepTime, 'NA', '000') as CRSDepTime2,
        replace(ArrTime, 'NA', '000') as ArrTime2,
        replace(CRSArrTime, 'NA', '000') as CRSArrTime2;

rita1 = foreach rita0 generate $0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,
        Month2, DayofMonth2, CONCAT('0',DepTime2) as DepTime3, 
        CONCAT('0',CRSDepTime2) as CRSDepTime3, 
        CONCAT('0',ArrTime2) as ArrTime3, 
        CONCAT('0',CRSArrTime2) as CRSArrTime3;

rita2 = foreach rita1 generate $0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,
        Month2, DayofMonth2, 
        substring(DepTime3,(int)SIZE(DepTime3)-4,(int)SIZE(DepTime3)) as DepTime4,
        substring(CRSDepTime3,(int)SIZE(CRSDepTime3)-4,(int)SIZE(CRSDepTime3)) as CRSDepTime4,
        substring(ArrTime3,(int)SIZE(ArrTime3)-4,(int)SIZE(ArrTime3)) as ArrTime4,
        substring(CRSArrTime3,(int)SIZE(CRSArrTime3)-4,(int)SIZE(CRSArrTime3)) as CRSArrTime4;


rita3 = foreach rita2 generate Year, Month2 as Month, DayofMonth2 as DayofMonth, $3,
        DepTime4 as DepTime, CRSDepTime4 as CRSDepTime, ArrTime4 as ArrTime, CRSArrTime4 as CRSArrTime, 
        $8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28, 
        CONCAT(Year,CONCAT('-',CONCAT(Month2,CONCAT('-',CONCAT(DayofMonth2,CONCAT(' ',CONCAT(substring(CRSDepTime4,0,2),CONCAT(':',CONCAT(substring(CRSDepTime4,2,4),':00'))))))))) as flight_date;


por_aerolinea = GROUP rita3 by UniqueCarrier;

por_aerolinea_f  = foreach por_aerolinea generate flatten($1);

prueba = LIMIT por_aerolinea_f 5;

vuelos = FOREACH por_aerolinea_f {
    numeros = DISTINCT FlightNum;
    GENERATE UniqueCarrier, COUNT (numeros) as cuenta;
} 

vuelos_ord = ORDER vuelos BY cuenta;

prueba = LIMIT vuelos_ord 5;

store vuelos_ord into 'vuelos_ord' using PigStorage(',');

