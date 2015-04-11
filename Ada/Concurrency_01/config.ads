--------------------------------------------------------------------------------
-- Package : config
-- Content : defined constant values that are used in whole project
--
-- NumberOfWorkers : total number of workers, that will work in company
-- MaximalTaskVectorSize : size of vector that contains tasks
-- MaximalProductVectorSize : size of vector that contains products
-- WorkersGoingToWorkTime : time, after which worker will start working
-- WorkersBreak : break between solving tasks by worker
-- CustomerGoingToStoreTime : time, after which customer will start buying
-- CustomerBreak : break between buying products by customer
-- WorkerEmploymentTime : break beetween initialisation another worker
-- TaxOfficerWorkTime : break before another intruction to taxofficer
--
-- CompanyTalkative : program mode
-- Talkative : true
-- every processes will put message what are they currently doing
-- Talkative : false
-- taxofficer will ask in loop, which information should be wrote in console
--
-- Author : Adam Szerszen
-- Index : 194133
--------------------------------------------------------------------------------

package config is

   NumberOfWorkers : constant Integer := 3;
   MaximalTaskVectorSize : constant Integer := 8;
   MaximalProductVectorSize : constant Integer := 5;
   WorkersGoingToWorkTime : constant Standard.Duration := 2.0;
   WorkersBreak : constant Standard.Duration := 3.0;
   CustomerGoingToStoreTime : constant Standard.Duration := 5.0;
   CustomerBreak : constant Standard.Duration := 1.0;
   WorkerEmploymentTime : constant Standard.Duration := 3.0;
   TaxOfficerWorkTime : constant Standard.Duration := 8.0;
   CompanyTalkative : constant Boolean := False;

end config;
