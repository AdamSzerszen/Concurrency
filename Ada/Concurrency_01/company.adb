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
                                   Operator => (counter mod 3));
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
      tempProduct : ProductPointer;
   begin
      delay WorkersGoingToWorkTime;
      loop
         taskServer.PopTask(tempTask);
         tempProduct := CreateProduct(resolvedTask => tempTask);
         if CompanyTalkative then
            Put("Worker number ");
            Put(Integer'Image(number));
            Put(" solved task: ");
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

         ProductServer.AddProduct(tempProduct);
         delay WorkersBreak;
      end loop;
   end Worker;

   task body Customer is

      tempProduct : ProductPointer;
   begin
      delay CustomerGoingToStoreTime;
      loop
         productServer.PopProduct(tempProduct);

         if CompanyTalkative then
            Put("Product bought: ");
            Put(Integer'Image(tempProduct.ResolvedTask.ParamA));
            Put(" ");
            if tempProduct.ResolvedTask.Operator = 0 then
               Put("+");
            end if;
            if tempProduct.ResolvedTask.Operator = 1 then
               Put("-");
            end if;
            if tempProduct.ResolvedTask.Operator = 2 then
               Put("*");
            end if;
            Put(Integer'Image(tempProduct.ResolvedTask.ParamB));
            Put(" = ");
            Put(Integer'Image(tempProduct.Solution));
            Put_Line("");
         end if;

         delay WorkersBreak;
      end loop;
   end Customer;

   task body TaxOffice is
      RawCommand : String(1 ..1);
      Command : Integer := 0;
      dataOne : Integer := 0;
      dataTwo : Integer := 0;
      dataThree : Integer := 0;
      dataFour : Integer := 0;
      dataFive : Integer := 0;
      Last : Integer;
   begin
      if CompanyTalkative = False then
         loop
            Put_Line("Please put command:");
            Put_Line("1 : Show number of tasks waiting in vector");
            Put_Line("2 : Show number of tasks created in total");
            Put_Line("3 : Show number of products waiting in vector");
            Put_Line("4 : Show number of products created in total");
            Put_Line("5 : Show number of products bought in total");


            taskServer.TasksStatus(dataOne, dataTwo);
            productServer.ProductsStatus(dataThree, dataFour, dataFive);
            Get_Line(RawCommand, Last);
            Command := Integer'Value(RawCommand);
            if Command = 1 then
               Put("Number of tasks waiting in vector: ");
               Put_Line(Integer'Image(dataOne));
            end if;
            if Command = 2 then
               Put("Number of tasks created in total: ");
               Put_Line(Integer'Image(dataTwo));
            end if;
            if Command = 3 then
               Put("Number of products waiting in vector: ");
               Put_Line(Integer'Image(dataThree));
            end if;
            if Command = 4 then
               Put("Number of products created in total: ");
               Put_Line(Integer'Image(dataFour));
            end if;
            if Command = 5 then
               Put("Number of products bought in total: ");
               Put_Line(Integer'Image(dataFive));
            end if;
            Command := 0;
            delay TaxOfficerWorkTime;
         end loop;
      end if;
   end TaxOffice;
end company;
