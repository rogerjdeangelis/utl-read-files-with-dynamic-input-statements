%let pgm=utl-read-files-with-dynamic-input-statements;

WARNING THIS MAY BE SLOW IF YOU HAVE A LARGE NUMBER OF FILES TO INGEST

Read files with dynamic input statements

GitHub                                                                            
https://tinyurl.com/2p95ssrn                                                      
https://github.com/rogerjdeangelis/utl-read-files-with-dynamic-input-statements   


/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data mta;
  filename="d:/txt/havOne.txt"; input_statement="age height   "; output="work.havOne"; output;
  filename="d:/txt/havTwo.txt"; input_statement="height weight"; output="work.havTwo"; output;
run;quit;

* create text files;
data _null_;
  set sashelp.class(obs=6);
  file "d:/txt/havOne.txt";
  if _n_ <= 3 then do;
     put     age height;
     putlog  age height;
  end;
  else do;
     file "d:/txt/havTwo.txt";
     put     height weight;
     putlog  height weight;
  end;
run;quit;

/***********************************************************/
/*                                                         */
/* Up to 40 obs WORK.MTA total obs=2 03MAR2022:08:45:38    */
/*                                                         */
/*                               INPUT_                    */
/* Obs        FILENAME         STATEMENT       OUTPUT      */
/*                                                         */
/*  1     d:/txt/havOne.txt    age height    work.havOne   */
/*  2     d:/txt/havTwo.txt    height wei    work.havOne   */
/*                                                         */
/*  d:/txt/havOne.txt                                      */
/*                                                         */
/*    14 69                                                */
/*    13 56.5                                              */
/*    13 65.3                                              */
/*                                                         */
/*  d:/txt/havTwo.txt                                      */
/*                                                         */
/*    62.8 102.5                                           */
/*    63.5 102.5                                           */
/*    57.3 83                                              */
/*                                                         */
/***********************************************************/

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/*****************************************************************************************/
/*                                                                                       */
/* Up to 40 obs WORK.LOG total obs=2 03MAR2022:09:15:04                                  */
/*                                                                                       */
/*                                INPUT_                                                 */
/* Obs        FILENAME           STATEMENT        OUTPUT       RC         STATUS         */
/*                                                                                       */
/*  1     d:/txt/havOne.txt    age height       work.havOne     0    SAS Table created   */
/*  2     d:/txt/havTwo.txt    height weight    work.havTwo     0    SAS Table created   */
/*                                                                                       */
/*                                                                                       */
/* Up to 40 obs from WORK.HAVONE total obs=3 03MAR2022:09:15:58                          */
/*                                                                                       */
/* Obs    HEIGHT    WEIGHT                                                               */
/*                                                                                       */
/*  1      62.8      102.5                                                               */
/*  2      63.5      102.5                                                               */
/*  3      57.3       83.0                                                               */
/*                                                                                       */
/*                                                                                       */
/* Up to 40 obs from WORK.HAVTWO total obs=3 03MAR2022:09:17:04                          */
/*                                                                                       */
/* Obs    HEIGHT    WEIGHT                                                               */
/*                                                                                       */
/*  1      62.8      102.5                                                               */
/*  2      63.5      102.5                                                               */
/*  3      57.3       83.0                                                               */
/*                                                                                       */
/*                                                                                       */
/*****************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%symdel filename input_statement output / nowarn;

data log;

 set mta;

 call symputx("filename",filename);
 call symputx("input_statement",input_statement);
 call symputx("output",output);

 rc=dosubl('

    proc datasets lib=work nolist nodetails mt=data mt=cat;
      delete sasmac1 sasmac2; * probably not needed;
    run;quit;

    data &output;
      infile "&filename";
      input &input_statement;
    run;quit;

    %let cc=&syserr;
    ');

    if symgetn('cc') = 0 then status="SAS Table created    ";
    else status="ERROR creating table";

run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
