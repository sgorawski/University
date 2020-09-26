package its;

import java.util.ArrayList;
import java.util.Collection;

public class Line {

    private String lineID;
    private String color;
    private int frequency;
    private ArrayList<Vertex> track;

    public Line(String lineID, String color, int frequency, ArrayList<Vertex> track) {
        this.lineID = lineID;
        this.color = color;
        this.frequency = frequency;
        this.track = track;
    }

    public String getLineID() {
        return lineID;
    }

    public String getColor() {
        return color;
    }

    public int getFrequency() {
        return frequency;
    }

    public boolean hasNextEdge(Vertex currentLoc) {
        int index = track.indexOf(currentLoc);
        return (index < track.size() - 1);
    }

    public Edge getNextEdge(Vertex currentLoc) {
        int index = track.indexOf(currentLoc);
        return currentLoc.getEdge(track.get(index + 1));
    }

    public Edge getNextEdge() {
        return track.get(0).getEdge(track.get(1));
    }
}
