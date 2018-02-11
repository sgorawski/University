package its;

public class Game implements Runnable {

    private SimulationController controller;

    public Game(SimulationController controller) {
        this.controller = controller;
    }

    @Override
    public void run() {
        while (!controller.stop) {
            controller.initializeNewVehicles();
            controller.moveAndRemove();

            if (controller.pause) synchronized (controller.monitor) {
                try {
                    controller.monitor.wait();
                } catch (InterruptedException ignored) {}
            }

            controller.nextIter();
            try {
                Thread.sleep(1000 / controller.speedUp);
            } catch (InterruptedException ignored) {}
        }
        controller.cleanUp();
    }
}
