package its;

public class LineData {
    private String lineID;
    private String color;
    private int frequency;
    private String[] verticesNames;

    public LineData(String lineID, String color, int frequency, String[] verticesNames) {
        this.lineID = lineID;
        this.color = color;
        this.frequency = frequency;
        this.verticesNames = verticesNames;
    }

    public String getLineID() { return lineID; }
    public String getColor() { return color; }
    public int getFrequency() { return frequency; }
    public String[] getVerticesNames() { return verticesNames; }
}
