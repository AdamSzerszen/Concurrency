package body servers is

   task body TaskServer is
      Tasks : TaskVector.Vector;
      Count : Integer := 0;
      MaxSize : Integer := MaximalTaskVectorSize;
      CreatedTasksTotal : Integer := 0;
   begin

      loop
         select
            when Count < MaxSize =>
               accept AddTask (taskToAdd : in TaskPointer) do
                  TaskVector.Insert(Container => Tasks,
                                    Before    => 1,
                                    New_Item  => taskToAdd);
                  Count := Count + 1;
                  CreatedTasksTotal := CreatedTasksTotal + 1;
               end AddTask;
         or
            when Count > 0 =>
               accept PopTask (popedTask : in out TaskPointer) do
                  popedTask := TaskVector.Element(TaskVector.Last(Container => Tasks));
                  TaskVector.Delete_Last(Container => Tasks);
                  Count := Count - 1;
               end PopTask;
         end select;
      end loop;
   end TaskServer;
end servers;
