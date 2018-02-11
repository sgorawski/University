package its;

import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.layout.VBox;

public class Sidebar extends VBox {
    private SimulationController controller;

    public Sidebar(SimulationController controller) {
        this.controller = controller;

        Label vmaxLbl = new Label("VMax [km/h]");
        vmaxLbl.getStyleClass().add("input-label");
        Slider vmax = createVMaxSlider();

        Label speedUpLbl = new Label("Speed up");
        speedUpLbl.getStyleClass().add("input-label");
        Slider speedUp = createSpeedUpSlider();

        Label distanceLbl = new Label("Distance");
        distanceLbl.getStyleClass().add("input-label");
        Slider distance = createDistanceSlider();

        Label timeLbl = new Label("Time");
        timeLbl.getStyleClass().add("input-label");
        Label time = new Label();
        time.textProperty().bind(controller.formattedIteration);
        time.getStyleClass().add("time-label");

        this.getStyleClass().add("sidebar");
        this.getChildren().addAll(vmaxLbl, vmax, speedUpLbl, speedUp, distanceLbl, distance, timeLbl, time);
    }

    /*
    CODE FOR APPLYING SLIDER VALUES LARGELY INSPIRED BY:
    https://stackoverflow.com/questions/18892070/javafx-2-2-hooking-slider-drag-n-drop-events
    ORIGINAL AUTHOR: JavadocMD
    */

    private Slider createVMaxSlider() {
        Slider slider = new Slider(10, 90, 40);
        slider.setMinorTickCount(0);
        slider.setMajorTickUnit(10);
        slider.setSnapToTicks(true);

        slider.valueProperty().addListener((observableValue, previous, now) -> {
            if (!slider.isValueChanging()
                    || now.doubleValue() == slider.getMax()
                    || now.doubleValue() == slider.getMin()) {
                controller.vehiclesVMax = slider.getValue() / 3.6;
            }
        });

        return slider;
    }

    private Slider createSpeedUpSlider() {
        Slider slider = new Slider(1, 16, 1);
        slider.setMinorTickCount(4);
        slider.setMajorTickUnit(5);
        slider.setSnapToTicks(true);
        slider.setBlockIncrement(1);

        slider.valueProperty().addListener((observableValue, previous, now) -> {
            if (!slider.isValueChanging()
                    || now.doubleValue() == slider.getMax()
                    || now.doubleValue() == slider.getMin()) {
                controller.speedUp = (int) slider.getValue();
            }
        });

        return slider;
    }

    private Slider createDistanceSlider() {
        Slider slider = new Slider(50, 500, 100);
        slider.setMinorTickCount(2);
        slider.setMajorTickUnit(150);
        slider.setSnapToTicks(true);
        slider.setBlockIncrement(50);

        slider.valueProperty().addListener((observableValue, previous, now) -> {
            if (!slider.isValueChanging()
                    || now.doubleValue() == slider.getMax()
                    || now.doubleValue() == slider.getMin()) {
                controller.distance = slider.getValue();
            }
        });

        return slider;
    }
}
