import java.util.Map;

public class EnvMap {
    public static void main (String[] args) throws Exception {
        System.out.println("Hello world");
        System.out.println("this is a binary built with native-image via Cosmo Libc");
        var filter = args.length > 0 ? args[0] : "";
        Map<String, String> env = System.getenv();
        for (String envName : env.keySet()) {
            if(envName.contains(filter)) {
                System.out.format("%s=%s%n",
                        envName,
                        env.get(envName));
            }
        } 
        System.out.println("(sorry for hax)\n\n\n\n");
        tryThreading();
    }

    public static void tryThreading () {
        // Create and start multiple threads
        Thread t1 = new Thread(new CounterTask("Thread A", 1, 5));
        Thread t2 = new Thread(new CounterTask("Thread B", 100, 105));
        Thread t3 = new Thread(new CounterTask("Thread C", 1000, 1005));

        t1.start();
        t2.start();
        t3.start();

        // Wait for all threads to complete
        try {
            t1.join();
            t2.join();
            t3.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("All threads completed!");
    }
}

class CounterTask implements Runnable {
    private String name;
    private int start;
    private int end;

    public CounterTask(String name, int start, int end) {
        this.name = name;
        this.start = start;
        this.end = end;
    }

    @Override
    public void run() {
        for (int i = start; i <= end; i++) {
            System.out.println(name + ": " + i);
            try {
                Thread.sleep(100); // Small delay to see interleaving
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
