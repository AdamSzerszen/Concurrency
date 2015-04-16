with Ada.Containers.Vectors;
with config; use config;

package collections is

   type TaskToDo;
   type TaskPointer is access TaskToDo;
   type TaskToDo is record

      ParamA : Integer;
      ParamB : Integer;
      Operator : Integer;
      Solution : Integer;
   end record;

   function CreateTask (parameterA : in Integer;
                        parameterB : in Integer; operator : in Integer)
                        return TaskPointer;

   subtype TasksRange is Positive range 1 .. MaximalTaskVectorSize;

   package TaskVector is new Ada.Containers.Vectors
     (Index_Type   => TasksRange,
      Element_Type => TaskPointer);

end collections;
