with servers; use servers;
with company; use company;
with Ada.Text_IO; use Ada.Text_IO;
with config; use config;

procedure Main is

   taskServerPointer : servers.TaskServerPointer := new servers.TaskServer;
   productServerPointer : servers.ProductServerPointer := new servers.ProductServer;
   chairman : company.Chairman(taskServerPointer);
   type workerPointer  is access company.Worker;
   workers : array(1..NumberOfWorkers) of workerPointer;
   customer : company.Customer(productServerPointer);
   taxOfficer : company.TaxOffice(taskServerPointer, productServerPointer);
begin
   for i in 1..NumberOfWorkers loop
      workers(i) := new company.Worker(taskServerPointer,
                                       productServerPointer,
                                       i);
      if CompanyTalkative then
         Put("Worker number ");
         Put(Integer'Image(i));
         Put_Line(" started his day!");
      end if;
      delay WorkerEmploymentTime;
   end loop;
   --  TODO LIST:
   --  1. Table of workers, each of them starts after delay time ` DONE!
   --  2. Random breaks after creating new tasks by chairman       DONE!
   --  3. Config file                                              DONE!
   --  4. Implement second mode (interaction with user)
   --  5. Third server (entry with taskList and productList)       DONE!
   null;
end Main;
