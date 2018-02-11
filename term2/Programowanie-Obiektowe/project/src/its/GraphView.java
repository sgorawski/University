package its;

import javafx.beans.binding.Bindings;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.event.Event;
import javafx.geometry.Bounds;
import javafx.geometry.Point2D;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Pane;
import javafx.scene.layout.Region;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;

import java.util.ArrayList;
import java.util.Collection;

public class GraphView extends StackPane {

    private Pane edgesPane;
    private Pane verticesPane;
    private Pane labelsPane;

    public GraphView() {
        this.edgesPane = new Pane();
        this.verticesPane = new Pane();
        this.labelsPane = new Pane();
        this.getChildren().addAll(edgesPane, labelsPane, verticesPane);
    }

    public void initGridView(Iterable<Edge> edges, Iterable<Vertex> vertices) {
        for (Vertex vertex: vertices
                ) {
            addVertex(vertex);
            addLabel(vertex);
        }

        for (Edge edge: edges
             ) {
            addEdge(edge);
        }
    }

    private void addVertex(Vertex newVertex) {
        verticesPane.getChildren().add(createVertexElement(newVertex));
    }

    private void addLabel(Vertex vertex) {
        labelsPane.getChildren().add(createLabel(vertex, vertex.getName()));
    }

    private void addEdge(Edge newEdge) {
        edgesPane.getChildren().add(createConnection(newEdge.getStartVertex(), newEdge.getFinishVertex()));
    }

    /*
    PARTS OF THE CODE FOR THE FOLLOWING METHODS WERE TAKEN FROM
    https://stackoverflow.com/questions/35595282/connect-two-nodes-with-an-edge-javafx
    ORIGINAL AUTHOR: James_D
    */
    private Vertex createVertexElement(Vertex vertex) {

        ObjectProperty<Point2D> mouseLoc = new SimpleObjectProperty<>();
        vertex.setOnMousePressed(e -> mouseLoc.set(new Point2D(e.getX(), e.getY())));
        vertex.setOnMouseDragged(e -> {
            double deltaX = e.getX() - mouseLoc.get().getX();
            double deltaY = e.getY() - mouseLoc.get().getY();
            if (vertex.getCenterX() + deltaX >= 0)
                vertex.setCenterX(vertex.getCenterX() + deltaX);
            else
                vertex.setCenterX(0);
            if (vertex.getCenterY() + deltaY >= 0)
                vertex.setCenterY(vertex.getCenterY() + deltaY);
            else
                vertex.setCenterY(0);

            mouseLoc.set(new Point2D(e.getX(), e.getY()));
        });
        vertex.addEventFilter(MouseEvent.MOUSE_CLICKED, Event::consume);
        return vertex;
    }

    protected Label createLabel(Node n, String text) {
        Label label = new Label(text);
        label.getStyleClass().add("grid-label");

        label.layoutXProperty().bind(Bindings.createDoubleBinding(() -> {
            Bounds b = n.getBoundsInParent();
            return b.getMinX() + b.getWidth() / 2 + 8;
        }, n.boundsInParentProperty()));
        label.layoutYProperty().bind(Bindings.createDoubleBinding(() -> {
            Bounds b = n.getBoundsInParent();
            return b.getMinY() + b.getHeight() / 2 - 4;
        }, n.boundsInParentProperty()));

        return label;
    }

    private Line createConnection(Node n1, Node n2) {
        Line line = new Line();

        line.startXProperty().bind(Bindings.createDoubleBinding(() -> {
            Bounds b = n1.getBoundsInParent();
            return b.getMinX() + b.getWidth() / 2;
        }, n1.boundsInParentProperty()));
        line.startYProperty().bind(Bindings.createDoubleBinding(() -> {
            Bounds b = n1.getBoundsInParent();
            return b.getMinY() + b.getHeight() / 2;
        }, n1.boundsInParentProperty()));

        line.endXProperty().bind(Bindings.createDoubleBinding(() -> {
            Bounds b = n2.getBoundsInParent();
            return b.getMinX() + b.getWidth() / 2;
        }, n2.boundsInParentProperty()));
        line.endYProperty().bind(Bindings.createDoubleBinding(() -> {
            Bounds b = n2.getBoundsInParent();
            return b.getMinY() + b.getHeight() / 2;
        }, n2.boundsInParentProperty()));

        return line;
    }

}
