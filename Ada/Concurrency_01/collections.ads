--------------------------------------------------------------------------------
-- Package : collections
-- Content : package with records, functions creating them, and appended
--           generic vector package
--
-- TaskToDo : record of task created by chairman
-- ParamA : first parameter of aritmetic operation
-- ParamB : second parameter of aritmetic operation
-- Operator : type of aritmetic operation ( 0 +, 1 -, 2 *)
--
-- Product : record of solved task, created by worker
-- ResolvedTask : task which solution is in
-- Solution : solution of task
--
-- function CreateTask : create task, returns pointer to it
-- param0 : ParamA
-- param1 : ParamB
-- param2 : Operator
--
-- function CreateProduct : solve task, returns pointer to created product
-- param0 : resolvedTask
--
-- TasksRange : subtype range of vector that contains tasks
-- ProductsRange : subtype range of vector that contains products
--
-- Author : Adam Szerszen
-- Index : 194133
--------------------------------------------------------------------------------

with Ada.Containers.Vectors;
with config; use config;

package collections is

   type TaskToDo;
   type TaskPointer is access TaskToDo;
   type TaskToDo is record

      ParamA : Integer;
      ParamB : Integer;
      Operator : Integer;
   end record;

   type Product;
   type ProductPointer is access Product;
   type Product is record

      ResolvedTask : TaskPointer;
      Solution : Integer;
   end record;

   function CreateTask (parameterA : in Integer;
                        parameterB : in Integer; operator : in Integer)
                        return TaskPointer;

   function CreateProduct (resolvedTask : in TaskPointer) return ProductPointer;

   subtype TasksRange is Positive range 1 .. MaximalTaskVectorSize;
   subtype ProductRange is Positive range 1 .. MaximalProductVectorSize;

   package TaskVector is new Ada.Containers.Vectors
     (Index_Type   => TasksRange,
      Element_Type => TaskPointer);

   package ProductVector is new Ada.Containers.Vectors
     (Index_Type   => ProductRange,
      Element_Type => ProductPointer);

end collections;
