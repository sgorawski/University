package its;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class SimulationModel extends GraphModel {
    private ArrayList<Line> lines;
    private Collection<Vehicle> vehicles;

    public SimulationModel(HashMap<String, Vertex> adjacencyDict) {
        this.adjacencyDict = adjacencyDict;
        this.lines = new ArrayList<>();
        this.vehicles = new ArrayList<>();
    }

    public void readDataFromFiles(String linesPath) throws IOException {
        Collection<LineData> linesData = DataParser.readLinesFromFile(linesPath);
        String[] verticesNames;
        ArrayList<Vertex> verticesOrder = new ArrayList<>();
        ArrayList<Vertex> verticesOrderRv = new ArrayList<>();
        for (LineData lineData : linesData
                ) {
            verticesNames = lineData.getVerticesNames();
            verticesOrder.clear();
            verticesOrderRv.clear();
            verticesOrder.addAll(Arrays.stream(verticesNames).map(vname -> adjacencyDict.get(vname)).collect(Collectors.toList()));

            lines.add(new Line(lineData.getLineID(), lineData.getColor(), lineData.getFrequency(), new ArrayList<>(verticesOrder)));
            for (int i = verticesOrder.size() - 1; i >= 0; i--) {
                verticesOrderRv.add(verticesOrder.get(i));
            }
            lines.add(new Line(lineData.getLineID(), lineData.getColor(), lineData.getFrequency(), new ArrayList<>(verticesOrderRv)));
        }
    }

    public Collection<Line> getLines() {
        return lines;
    }

    public Collection<Vehicle> getVehicles() {
        return vehicles;
    }

    public Vehicle createVehicle(Line line) {
        Vehicle vehicle = new Vehicle(line);
        vehicle.setStyle(String.format("-fx-fill: #%s;", line.getColor()));
        vehicles.add(vehicle);
        return vehicle;
    }

    public Collection<Vehicle> moveVehicles(double deltaTime, double vmax, double distance) {
        ArrayList<Vehicle> vehiclesToRemove = new ArrayList<>();
        for (Vehicle vehicle : vehicles) {
             if (!vehicle.move(deltaTime, vmax, distance)) {
                 vehiclesToRemove.add(vehicle);
             }
        }
        vehicles.removeAll(vehiclesToRemove);
        return vehiclesToRemove;
    }
}
