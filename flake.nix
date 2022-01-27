{
  description = "Collection of flake templates";

  outputs = { self }: {

    templates = {

      cpp-library = {
        path = ./cpp-library;
        description = "C++ / cmake library template";
      };

      qt-application = {
        path = ./qt-application;
        description = "Qt application with cmake template";
      };

    };

  };
}
