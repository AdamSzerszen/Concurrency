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
         or
              when CreatedTasksTotal > 5 =>
               accept TasksStatus (tasksReport : in out TaskReportPointer) do
                  tasksReport := CreateTaskReport(CreatedTasksTotal, Count,
                                                  TaskVector.Copy(Source   => Tasks));
               end TasksStatus;
         end select;
      end loop;
   end TaskServer;

   task body ProductServer is
      Products : ProductVector.Vector;
      Count : Integer := 0;
      CreatedProductsTotal : Integer := 0;
      BoughtProductsTotal : Integer := 0;
      MaxSize : Integer := MaximalProductVectorSize;
   begin

      loop
         select
            when Count < MaxSize =>
               accept AddProduct (productToAdd : in ProductPointer) do
                  ProductVector.Insert(Container => Products,
                                       Before    => 1,
                                       New_Item  => productToAdd);
                  Count := Count + 1;
                  CreatedProductsTotal := CreatedProductsTotal + 1;
               end AddProduct;
         or
            when Count > 0 =>
               accept PopProduct (popedProduct : in out ProductPointer) do
                  popedProduct := ProductVector.Element(ProductVector.Last(Container => Products));
                  ProductVector.Delete_Last(Container => Products);
                  Count := Count - 1;
                  BoughtProductsTotal := BoughtProductsTotal + 1;
               end PopProduct;
         or
            when CreatedProductsTotal > 5 =>
               accept ProductsStatus (productsReport : in out ProductReportPointer) do
                  productsReport := CreateProductReport(CreatedProductsTotal, Count,
                                                       ProductVector.Copy(Source   => Products));
               end ProductsStatus;
         end select;
      end loop;
   end ProductServer;

end servers;
