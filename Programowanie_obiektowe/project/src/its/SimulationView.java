package its;

import javafx.scene.Node;
import javafx.scene.layout.Pane;

import java.util.Collection;
import java.util.HashMap;

public class SimulationView extends GraphView {

    private Pane vehiclesPane;
    private Pane labelsPane;
    private HashMap<Node, Node> vehiclesLabels;

    public SimulationView(Collection<Node> background) {
        this.vehiclesPane = new Pane();
        this.labelsPane = new Pane();
        this.vehiclesLabels = new HashMap<>();
        this.getChildren().addAll(background);
        this.getChildren().addAll(vehiclesPane, labelsPane);
    }

    public void addVehicle(Vehicle newVehicle) {
        vehiclesPane.getChildren().add(newVehicle);
        Node newLabel = createLabel(newVehicle, newVehicle.getLabel());
        labelsPane.getChildren().add(newLabel);
        vehiclesLabels.put(newVehicle, newLabel);
    }

    public void removeVehicles(Collection<Vehicle> vehiclesToRemove) {
        for (Vehicle veh : vehiclesToRemove) {
            vehiclesPane.getChildren().remove(veh);
            labelsPane.getChildren().remove(vehiclesLabels.get(veh));
            vehiclesLabels.remove(veh);
        }
    }
}
