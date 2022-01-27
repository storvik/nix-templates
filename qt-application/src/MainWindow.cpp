#include "MainWindow.h"

/**
 * MainWindow constuctor, should setup entire main window class and make
 * any connections required in the main window ui.
 */
MainWindow::MainWindow(QWidget* parent) : QMainWindow(parent) { _ui.setupUi(this); }

/**
 * MainWindow destructor.
 */
MainWindow::~MainWindow() {}
