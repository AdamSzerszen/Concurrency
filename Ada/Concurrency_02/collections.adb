package body collections is

   function CreateTask (parameterA : in Integer;
                        parameterB : in Integer;
                        operator : in Integer) return TaskPointer is

      tempTask : TaskPointer;

   begin
      tempTask := new TaskToDo'(ParamA   => parameterA,
                                ParamB   => parameterB,
                                Operator => operator,
                                Solution => -666);
      return tempTask;
   end CreateTask;


end collections;
