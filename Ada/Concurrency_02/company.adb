package body company is

task body Chairman is

      tempTask : TaskPointer;
      counter : Integer := 1;
      G : Generator;
   begin
      Reset(G, 1);
      loop
         tempTask := new TaskToDo'(ParamA   => counter,
                                   ParamB   => counter + 2,
                                   Operator => (counter mod 3),
                                  Solution => -666);
         taskServer.AddTask(tempTask);

         if CompanyTalkative then
            Put("Created task number ");
            Put(Integer'Image(counter));
            Put(". :");
            Put(Integer'Image(tempTask.ParamA));
            Put(" ");
            if tempTask.Operator = 0 then
               Put("+");
            end if;
            if tempTask.Operator = 1 then
               Put("-");
            end if;
            if tempTask.Operator = 2 then
               Put("*");
            end if;
            Put(Integer'Image(tempTask.ParamB));
            Put_Line("");
         end if;
         counter := counter + 1;

         delay 0.1+Duration(3.0*Random(G));
      end loop;
   end Chairman;

   task body Worker is

      tempTask : TaskPointer;
      tempMultipleMachine : MultipleMachinePtr;
      tempAddMachine : AddMachinePtr;
      tempMinusMachine : MinusMachinePtr;
      G : Generator;
      goForHelp : boolPtr := new Boolean'(False);
      type Rand_Range is range 0..9;
      package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
      seed : Rand_Int.Generator;

   begin
      delay WorkersGoingToWorkTime;
      Reset(G, 5);
      loop
         multipleMachinesWithTasks.NeedHelp(goForHelp);
         if goForHelp.All /= True then
            Put_Line("New worker tour");
            taskServer.PopTask(tempTask);
            Put_Line("Get task!");
            if tempTask.Operator = 0 then
               --              Put_Line("Have task, going for machine!");
               unscheduledAddMachines.UseAsSolver(tempAddMachine);
               ScrewUpAdding(tempAddMachine);
               while tempAddMachine.IsDamage loop
                  damagedAddMachines.ApplyDamagedMachine(tempAddMachine);
                  unscheduledAddMachines.UseAsSolver(tempAddMachine);
                  ScrewUpAdding(tempAddMachine);
               end loop;
               --             Put_Line("Have task and machine!");
               tempAddMachine.UseAsSolver(tempTask);
               --           Put_Line("Using machine!");
               unscheduledAddMachines.LeaveAsSolver(tempAddMachine);
               --         Put_Line("Machine left!");
               productServer.AddTask(tempTask);
               --       Put_Line("Task left");
            end if;
            if tempTask.Operator = 1 then
               Put_Line("Have task, going for machine!");
               unscheduledMinusMachines.UseAsSolver(tempMinusMachine);
               Put_Line("Have task and machine!");
               ScrewUpMinusing(tempMinusMachine);
               while tempMinusMachine.IsDamage loop
                  damagedMinusMachines.ApplyDamagedMachine(tempMinusMachine);
                  unscheduledMinusMachines.UseAsSolver(tempMinusMachine);
                  ScrewUpMinusing(tempMinusMachine);
               end loop;
               tempMinusMachine.UseAsSolver(tempTask);
               Put_Line("Using machine!");
               unscheduledMinusMachines.LeaveAsSolver(tempMinusMachine);
               Put_Line("Machine left!");
               productServer.AddTask(tempTask);
               Put_Line("Task left");
            end if;
            if tempTask.Operator = 2 then
               unscheduledMultipleMachines.UseAsSolver(tempMultipleMachine);
               ScrewUpMultippling(tempMultipleMachine);
               while tempMultipleMachine.IsDamage loop
                  damagedMultipleMachines.ApplyDamagedMachine(tempMultipleMachine);
                  unscheduledMultipleMachines.UseAsSolver(tempMultipleMachine);
                  ScrewUpMultippling(tempMultipleMachine);
               end loop;
               multipleMachinesWithTasks.AskForHelp(tempMultipleMachine);
               tempMultipleMachine.UseAsSolver(tempTask);
               unscheduledMultipleMachines.LeaveAsSolver(tempMultipleMachine);
               productServer.AddTask(tempTask);
            end if;
         else
            Put_Line("Worker wanna help!");
            multipleMachinesWithTasks.UseAsHelper(tempMultipleMachine);
            Put_Line("Worker pushing button!");
            tempMultipleMachine.UseAsHelper;
            Put_Line("Worker healped");
         end if;

         delay WorkersBreak;
      end loop;
   end Worker;

   task body Customer is

      tempProduct : TaskPointer;
   begin
      delay CustomerGoingToStoreTime;
      loop
         productServer.PopTask(tempProduct);

         if CompanyTalkative then
            Put("Product bought: ");
            Put(Integer'Image(tempProduct.ParamA));
            Put(" ");
            if tempProduct.Operator = 0 then
               Put("+");
            end if;
            if tempProduct.Operator = 1 then
               Put("-");
            end if;
            if tempProduct.Operator = 2 then
               Put("*");
            end if;
            Put(Integer'Image(tempProduct.ParamB));
            Put(" = ");
            Put(Integer'Image(tempProduct.Solution));
            Put_Line("");
         end if;
         delay WorkersBreak;
      end loop;
   end Customer;

   task body Handyman is
   begin
      loop
         delay HandymanBreakTime;
         damagedMultipleMachines.Repair(unscheduledMultipleMachines);
         damagedAddMachines.Repair(unscheduledAddMachines);
         damagedMinusMachines.Repair(unscheduledMinusMachines);
      end loop;
   end Handyman;
   procedure ScrewUpAdding (addMachine : in out AddMachinePtr) is
      G : Generator;
      random : Float := 0.0;
   begin
      Reset(G, 1);
      random := 3.0 * Random(G);
      if random > 2.5 then
         addMachine.Damage;
         Put_Line("Adding machine is broken!");
      end if;
   end ScrewUpAdding;

   procedure ScrewUpMinusing (minusMachine : in out MinusMachinePtr) is
      G : Generator;
      random : Float := 0.0;
   begin
      Reset(G, 1);
      random := (3.0 * Random(G));
      if random > 2.5 then
         minusMachine.Damage;
         Put_Line("Minusing machine is broken!");
      end if;
   end ScrewUpMinusing;

   procedure ScrewUpMultippling (multipleMachine : in out MultipleMachinePtr) is
      G : Generator;
      random : Float := 0.0;
   begin
      Reset(G, 1);
      random := 3.0 * Random(G);
      if random > 2.5 then
         multipleMachine.Damage;
         Put_Line("Multippling machine is broken!");
      end if;
   end ScrewUpMultippling;
end company;
