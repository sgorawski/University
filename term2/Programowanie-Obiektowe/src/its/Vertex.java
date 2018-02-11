package its;

import javafx.scene.shape.Circle;

import java.util.ArrayList;

public class Vertex extends Circle {
    // PROPERTIES
    private String name;
    private ArrayList<Edge> outgoingEdges;

    // CONSTRUCTOR
    public Vertex(String name) {
        super(10, 10,5);
        this.name = name;
        this.outgoingEdges = new ArrayList<>();
    }

    public Vertex(String name, double x, double y) {
        super(x, y, 5);
        this.name = name;
        this.outgoingEdges = new ArrayList<>();
    }

    // GET PROPERTIES
    public String getName() {
        return this.name;
    }

    Edge[] getArrayOfEdges() {
        return outgoingEdges.toArray(new Edge[outgoingEdges.size()]);
    }

    // EDGES MANIPULATION
    // There can only be one edge from v1 to v2
    boolean addEdge(Edge newEdge) {
        if (this.containsEdge(newEdge.getFinishVertex())) {
            return false;
        }
        outgoingEdges.add(newEdge);
        return true;
    }

    boolean containsEdge(Vertex finish) {
        for (Edge edge: outgoingEdges
             ) {
            if (edge.getFinishVertex() == finish) {
                return true;
            }
        }
        return false;
    }

    Edge getEdge(Vertex finish) {
        for (Edge edge: outgoingEdges
                ) {
            if (edge.getFinishVertex() == finish) {
                return edge;
            }
        }
        return null;
    }

    void removeEdge(Vertex finish) {
        for (Edge edge: outgoingEdges
             ) {
            if (edge.getFinishVertex() == finish) {
                outgoingEdges.remove(edge);
            }
        }
    }
}
