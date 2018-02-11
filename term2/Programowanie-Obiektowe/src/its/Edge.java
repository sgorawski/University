package its;

import java.util.ArrayList;
import java.util.Collection;

public class Edge {
    // PROPERTIES
    private Vertex start;
    private Vertex finish;
    private double cost;
    public Collection<Vehicle> currentVehicles;

    // CONSTRUCTOR
    public Edge(Vertex start, Vertex finish, double cost) {
        this.start = start;
        this.finish = finish;
        this.cost = cost;
        this.currentVehicles = new ArrayList<>();
    }

    // TO STRING
    @Override
    public String toString() {
        return String.format("Edge from %s to %s, cost: %f", start.getName(), finish.getName(), cost);
    }

    // GET PROPERTIES
    Vertex getStartVertex() {
        return start;
    }

    Vertex getFinishVertex() {
        return finish;
    }

    double getCost() {
        return cost;
    }
}
