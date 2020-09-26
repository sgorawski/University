package its;

import javafx.util.Pair;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.zip.DataFormatException;

public class DataParser {

    public static List<Vertex> readVerticesFromFile(String path) throws IOException {
        List<String> lines = Files.readAllLines(Paths.get(path), Charset.defaultCharset());
        return lines.stream()
            .map(vtx -> {
                try {
                    return toVertex(vtx);
                } catch (DataFormatException e) {
                    return null;
                }
            })
            .filter(Objects::nonNull)
            .collect(Collectors.toList());
    }

    public static void saveVerticesToFile(Iterable<Vertex> vertices, String path) throws IOException {
        if (Files.notExists(Paths.get(path), LinkOption.NOFOLLOW_LINKS)) {
            Files.createFile(Paths.get(path));
        }
        try (PrintWriter out = new PrintWriter(path)) {
            for (Vertex vertex : vertices) {
                out.println(String.format("%s:%f:%f", vertex.getName(), vertex.getCenterX(), vertex.getCenterY()));
            }
        }
    }

    private static Vertex toVertex(String vtx) throws DataFormatException {
        String[] parts = vtx.split(":");
        if (parts.length == 1) {
            return new Vertex(parts[0].trim());
        }
        if (parts.length == 3) {
            return new Vertex(
                parts[0].trim(),
                Double.parseDouble(parts[1].trim().replace(",", ".")),
                Double.parseDouble(parts[2].trim().replace(",", "."))
            );
        }
        throw new DataFormatException("Invalid input in the vertices file");
    }

    public static List<EdgeData> readEdgesFromFile(String path) throws IOException {
        List<String> lines = Files.readAllLines(Paths.get(path), Charset.defaultCharset());
        List<EdgeData> edges = new ArrayList<>();
        String[] els;

        for (String line : lines) {
            els = line.split(":");
            if (Pattern.compile("->").matcher(els[0]).find()) {
                String[] vertices = els[0].split("->");
                edges.add(new EdgeData(
                    vertices[0].trim(),
                    vertices[1].trim(),
                    Double.parseDouble(els[1].trim().replace(",", "."))
                ));
            }
            else if (Pattern.compile("-").matcher(els[0]).find()) {
                String[] vertices = els[0].split("-");
                edges.add(new EdgeData(
                    vertices[0].trim(),
                    vertices[1].trim(),
                    Double.parseDouble(els[1].trim().replace(",", "."))
                ));
                edges.add(new EdgeData(
                    vertices[1].trim(),
                    vertices[0].trim(),
                    Double.parseDouble(els[1].trim().replace(",", "."))
                ));
            }
        }
        return edges;
    }

    public static void saveEdgesToFile(Iterable<Edge> edges, String path) throws IOException {
        if (Files.notExists(Paths.get(path), LinkOption.NOFOLLOW_LINKS)) {
            Files.createFile(Paths.get(path));
        }
        try (PrintWriter out = new PrintWriter(path)) {
            for (Edge edge : edges) {
                out.println(String.format(
                    "%s -> %s:%f",
                    edge.getStartVertex().getName(),
                    edge.getFinishVertex().getName(),
                    edge.getCost()
                ));
            }
        }
    }

    public static Collection<LineData> readLinesFromFile(String path) throws IOException {
        List<String> lines = Files.readAllLines(Paths.get(path), Charset.defaultCharset());
        return lines.stream()
            .map(DataParser::toLine)
            .filter(Objects::nonNull)
            .collect(Collectors.toList());
    }

    private static LineData toLine(String ln) {
        String[] params = ln.split(":");
        if (params.length < 4) { return null; }
        String[] verticesNames = params[3].split("-");
        return new LineData(
            params[0].trim(),
            params[1].trim(),
            Integer.parseInt(params[2].trim()),
            verticesNames
        );
    }
}
