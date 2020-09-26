package its;

import javafx.scene.shape.Circle;
import javafx.scene.transform.Translate;

import java.util.Collection;
import java.util.Collections;
import java.util.stream.Collectors;

public class Vehicle extends Circle {
    private Line line;
    private Edge currentEdge;
    public double progress;

    public Vehicle(Line line) {
        this.line = line;
        this.currentEdge = line.getNextEdge();
        currentEdge.currentVehicles.add(this);
        this.setCenterX(currentEdge.getStartVertex().getCenterX());
        this.setCenterY(currentEdge.getStartVertex().getCenterY());
        this.setRadius(3);
    }

    public String getLabel() {
        return line.getLineID();
    }

    public boolean move(double deltaTime, double vmax, double distance) {
        double step = adjustSpeed(vmax, deltaTime, distance);
        progress += step;

        if (progress >= currentEdge.getCost()) {
            if (!line.hasNextEdge(currentEdge.getFinishVertex())) {
                currentEdge.currentVehicles.remove(this);
                return false;
            }
            switchEdge();
            return true;
        }

        double relativeStep = step / currentEdge.getCost();
        double edgeLengthX = currentEdge.getFinishVertex().getCenterX() - currentEdge.getStartVertex().getCenterX();
        double edgeLengthY = currentEdge.getFinishVertex().getCenterY() - currentEdge.getStartVertex().getCenterY();

        this.setCenterX(this.getCenterX() + relativeStep * edgeLengthX);
        this.setCenterY(this.getCenterY() + relativeStep * edgeLengthY);

        return true;
    }

    private double adjustSpeed(double vmax, double deltaTime, double distance) {
        Collection<Double> obstaclesLocations =
                currentEdge.currentVehicles.stream()
                .map(vh -> vh.progress)
                .filter(p -> p > progress)
                .collect(Collectors.toList());
        if (!obstaclesLocations.isEmpty()) {
            double distToObstacle = Collections.min(obstaclesLocations) - progress;
            return Math.min(Math.max(0, distToObstacle - distance), vmax * deltaTime);
        }
        return vmax * deltaTime;
    }

    private void switchEdge() {
        currentEdge.currentVehicles.remove(this);
        currentEdge = line.getNextEdge(currentEdge.getFinishVertex());
        currentEdge.currentVehicles.add(this);
        progress = 0;

        this.setCenterX(currentEdge.getStartVertex().getCenterX());
        this.setCenterY(currentEdge.getStartVertex().getCenterY());
    }
}
