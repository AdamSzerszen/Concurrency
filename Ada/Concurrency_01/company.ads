--------------------------------------------------------------------------------
-- Package : company
-- Content : package contains four types of task
--
-- Chairman : task that creates taskToDo and send them to TaskServer
-- Worker : task that get taskToDo from server, solve it, create product and
--          send it to ProductServer
-- Customer : task that get product from ProductServer
-- TaxOffice : task that get informations from TaskServer and ProductServer
--             and write it in console
--
-- Author : Adam Szerszen
-- Index : 194133
--------------------------------------------------------------------------------

with servers; use servers;
with collections; use collections;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Random_Seeds; use Random_Seeds;
with config; use config;

package company is

   task type Chairman (taskServer : servers.TaskServerPointer);
   task type Worker (taskServer : servers.TaskServerPointer;
                     productServer : servers.ProductServerPointer;
                     number : Integer);
   task type Customer (productServer : servers.ProductServerPointer);
   task type TaxOffice (taskServer : servers.TaskServerPointer;
                       productServer : servers.ProductServerPointer);

end company;
