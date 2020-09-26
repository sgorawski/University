package its;

import javafx.application.Platform;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

public class SimulationController {

    private SimulationModel model;
    private SimulationView view;

    private Integer iteration;
    public StringProperty formattedIteration = new SimpleStringProperty(this, "iter", "0:00");

    public final Object monitor;
    public volatile boolean stop;
    public volatile boolean pause;

    public double vehiclesVMax = 40;
    public int speedUp = 1;
    public double distance = 100;

    public SimulationController(SimulationModel model, SimulationView view) {
        this.model = model;
        this.view = view;
        this.monitor = new Object();
        reset();
    }

    public void initializeNewVehicles() {
        for (Line ln : model.getLines()) {
            if (iteration % (ln.getFrequency() * 60) == 0) {
                Vehicle newVehicle = model.createVehicle(ln);
                Platform.runLater(() -> view.addVehicle(newVehicle));
            }
        }
    }

    public void moveAndRemove() {
        Platform.runLater(() -> view.removeVehicles(model.moveVehicles(1, vehiclesVMax, distance)));
    }

    public void cleanUp() {
        Platform.runLater(() -> view.removeVehicles(model.getVehicles()));
    }

    public void nextIter() {
        iteration++;
        Platform.runLater(() -> formattedIteration.setValue(String.format("%d:%02d", iteration / 60, iteration % 60)));
    }

    public void reset() {
        this.stop = true;
        this.pause = false;
        this.iteration = 0;
        Platform.runLater(() -> formattedIteration.setValue("0:00"));
    }
}
