{
  description = "Collection of flake templates";

  outputs = { self }: {

    templates = {

      cpp-library = {
        path = ./cpp-library;
        description = "C++ / cmake library template";
      };

    };

  };
}
