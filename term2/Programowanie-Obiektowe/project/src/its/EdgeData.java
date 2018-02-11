package its;

public class EdgeData {
    private final String startName;
    private final String finishName;
    private final Double cost;

    public EdgeData(String startName, String finishName, Double cost) {
        this.startName = startName;
        this.finishName = finishName;
        this.cost = cost;
    }

    public String getStartName() { return startName; }
    public String getFinishName() { return finishName; }
    public Double getCost() { return cost; }
}
