--------------------------------------------------------------------------------
-- Package : servers
-- Content : package contains two types of servers
--
-- TaskServer : server handling mechanism of adding and poping taskToDo
-- entry AddTask : if vector not full, add taskToDo to vector
-- entry PopTask : if vector not empty, pop taskToDo from vector
-- entry TaskStatus : returns informations about tasks
--
-- ProductServer : server handling mechanism of adding and poping products
-- entry AddProduct : if vector not full, add product to vector
-- entry PopProduct : if vector not empty, pop product from vector
-- entry ProductStatus : returns informations about products
--
-- Author : Adam Szerszen
-- Index : 194133

with collections; use collections;
with config; use config;
with Ada.Text_IO; use Ada.Text_IO;

package servers is

   task type TaskServer is
      entry AddTask (taskToAdd : in TaskPointer);
      entry PopTask (popedTask : in out TaskPointer);
      entry TasksStatus (tasksReport : in out TaskReportPointer);
   end TaskServer;

   type TaskServerPointer is access TaskServer;

   task type ProductServer is
      entry AddProduct (productToAdd : in ProductPointer);
      entry PopProduct (popedProduct : in out ProductPointer);
      entry ProductsStatus (productsReport : in out ProductReportPointer);
   end ProductServer;

   type ProductServerPointer is access ProductServer;

end servers;
