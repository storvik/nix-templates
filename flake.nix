{
  description = "Collection of flake templates";

  outputs = { self }: {
    templates = {
      cpp-library = {
        path = ./cpp-library;
        description = "C++ / cmake library template";
      };
      esp-idf = {
        path = ./esp-idf;
        description = "ESP IDF project template";
      };
      flutter-android = {
        path = ./flutter-android;
        description = "Flutter android template";
      };
      qt-application = {
        path = ./qt-application;
        description = "Qt application with cmake template";
      };
      rust = {
        path = ./rust;
        description = "Rust project template";
      };
    };
  };
}
