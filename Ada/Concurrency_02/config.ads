package config is

   NumberOfWorkers : constant Integer := 10;
   NumberOfCustomers : constant Integer := 3;
   MaximalTaskVectorSize : constant Integer := 8;
   MaximalProductVectorSize : constant Integer := 5;
   WorkersGoingToWorkTime : constant Standard.Duration := 2.0;
   WorkersBreak : constant Standard.Duration := 3.0;
   CustomerGoingToStoreTime : constant Standard.Duration := 5.0;
   CustomerBreak : constant Standard.Duration := 1.0;
   WorkerEmploymentTime : constant Standard.Duration := 3.0;
   TaxOfficerWorkTime : constant Standard.Duration := 8.0;
   CompanyTalkative : constant Boolean := True;
   NumberOfMultipleMachines : constant Integer := 3;
   NumberOfAddMachines : constant Integer := 3;
   NumberOfMinusMachines : constant Integer := 3;
   HandymanBreakTime : constant Standard.Duration := 5.0;
end config;
