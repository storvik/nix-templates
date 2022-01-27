#include <QtWidgets>

#include "MainWindow.h"

int main(int argc, char** argv) {
    QApplication app(argc, argv);

    MainWindow win;
    win.show();

    //  return 0 to indicate success
    return app.exec();
}
