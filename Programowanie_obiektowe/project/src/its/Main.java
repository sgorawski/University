package its;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

import javax.xml.soap.Text;
import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;

public class Main extends Application {

    private BorderPane ui;
    private HBox navbar;
    private HBox controls;

    @Override
    public void start(Stage primaryStage) throws Exception {
        File st = new File("assets/style.css");
        String pathToStyle = "file:///" + st.getAbsolutePath().replace("\\", "/");

        AnchorPane root = new AnchorPane();
        this.ui = new BorderPane();
        Scene scene = new Scene(root, 800, 600);
        scene.getStylesheets().add(pathToStyle);

        this.navbar = new HBox();
        navbar.getStyleClass().add("navbar");
        ui.setTop(navbar);

        this.controls = new HBox();
        controls.getStyleClass().add("controls");
        AnchorPane.setTopAnchor(ui, 0.0);
        AnchorPane.setLeftAnchor(ui, 0.0);
        AnchorPane.setRightAnchor(ui, 0.0);
        AnchorPane.setBottomAnchor(ui, 0.0);

        AnchorPane.setBottomAnchor(controls, 0.0);
        AnchorPane.setLeftAnchor(controls, 0.0);
        AnchorPane.setRightAnchor(controls, 0.0);
        root.getChildren().addAll(ui, controls);

        primaryStage.setTitle("ITS-project");
        primaryStage.setScene(scene);
        primaryStage.show();

        initSetupUI();
    }

    private void initSetupUI() {
        // CONTENT
        VBox input = new VBox();
        Label verticesLbl = new Label("Vertices");
        verticesLbl.getStyleClass().add("input-label");
        TextField verticesField = new TextField("data/vertices.txt");

        Label edgesLbl = new Label("Edges");
        edgesLbl.getStyleClass().add("input-label");
        TextField edgesField = new TextField("data/edges.txt");

        Label linesLbl = new Label("Lines");
        linesLbl.getStyleClass().add("input-label");
        TextField linesField = new TextField("data/lines.txt");

        input.getChildren().addAll(verticesLbl, verticesField, edgesLbl, edgesField, linesLbl, linesField);
        input.getStyleClass().add("input-menu");

        // NAVBAR
        Label lbl = new Label("Data loading");
        lbl.getStyleClass().add("nav-label");
        navbar.getChildren().clear();
        navbar.getChildren().add(lbl);

        // CONTROLS
        Button next = new Button("Load data");
        next.setOnMouseClicked(event -> initGridUI(verticesField.getText(), edgesField.getText(), linesField.getText()));
        controls.getChildren().clear();
        controls.getChildren().add(next);

        ui.setCenter(input);
    }

    private void initGridUI(String verticesPath, String edgesPath, String linesPath) {
        // CONTENT
        GraphModel graph = new GraphModel();
        try {
            graph.readDataFromFiles(verticesPath, edgesPath);
        } catch (IOException e) {
            throwError("Data reading failed", "Check path to vertices and edges file");
        }
        GraphView grid = new GraphView();
        grid.initGridView(graph.eachEdge(), graph.eachVertex());

        // NAVBAR
        Label lbl = new Label("Grid alignment");
        lbl.getStyleClass().add("nav-label");
        navbar.getChildren().clear();
        navbar.getChildren().addAll(lbl);

        // CONTROLS
        Button saveBtn = new Button("Save grid");
        saveBtn.setOnMouseClicked(event -> {
            try {
                graph.saveDataToFiles(verticesPath, edgesPath);
            } catch (IOException e) {
                throwError("Data saving failed", "Check path to vertices and edges file");
            }
        });
        Button next = new Button("Next");
        next.setOnMouseClicked(event -> initSimulationUI(linesPath, grid.getChildren(), graph.getAdjacencyDict()));

        controls.getChildren().clear();
        controls.getChildren().addAll(saveBtn, next);

        ui.setCenter(grid);
    }

    private void initSimulationUI(String linesPath, Collection<Node> grid, HashMap<String, Vertex> adjacencyDict) {
        // CONTENT
        SimulationModel model = new SimulationModel(adjacencyDict);
        SimulationView view = new SimulationView(grid);
        try {
            model.readDataFromFiles(linesPath);
        } catch (IOException e) {
            throwError("Data reading failed", "Check path to lines file");
        }
        SimulationController controller = new SimulationController(model, view);

        // NAVBAR
        Label lbl = new Label("Simulation");
        lbl.getStyleClass().add("nav-label");
        navbar.getChildren().clear();
        navbar.getChildren().addAll(lbl);

        // SIDEBAR
        VBox sidebar = new Sidebar(controller);
        ui.setLeft(sidebar);

        // CONTROLS
        Button pause = new Button("Pause");
        pause.setOnMouseClicked(event -> pause.setText(togglePause(controller)));
        pause.setVisible(false);

        Button stop = new Button("Start");
        stop.setOnMouseClicked(event -> {
            stop.setText(toggleStop(controller));
            pause.setText("Pause");
            pause.setVisible(!pause.isVisible());
        });

        controls.getChildren().clear();
        controls.getChildren().addAll(pause, stop);

        ui.setCenter(view);
    }

    // SIMULATION UI HELPER METHODS
    private void startSimulation(SimulationController controller) {
        Thread game = new Thread(new Game(controller));
        game.start();
    }

    private String togglePause(SimulationController controller) {
        if (!controller.pause) {
            controller.pause = true;
             return "Resume";
        }
        else {
            controller.pause = false;
            synchronized (controller.monitor) {
                controller.monitor.notifyAll();
            }
            return "Pause";
        }
    }

    private String toggleStop(SimulationController controller) {
        if (!controller.stop) {
            controller.stop = true;
            if (controller.pause) {
                togglePause(controller);
            }
            controller.reset();
            return "Start";
        }
        else {
            controller.stop = false;
            startSimulation(controller);
            return "Stop";
        }
    }

    private void throwError(String hdr, String msg) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Error");
        alert.setHeaderText(hdr);
        alert.setContentText(msg);
        alert.showAndWait();
        Platform.exit();
    }
}
