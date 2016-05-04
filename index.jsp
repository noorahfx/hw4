<%@page import="java.util.*, db.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>SOL Test Scores</title>
        <link href="hw4.css" rel="stylesheet" type="text/css">
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    </head>
    <body>
        <h1>Query</h1>
        <form method="get">
            <p>
                Division:
                <input id="div_num" name="div_num" type="text">
                School:
                <input id="sch_num" name="sch_num" type="text">
            </p>
            <p>
                Race:
                <select id="race" name="race">
                    <option value="ALL">ALL</option>
                    <option value="0">Unspecified</option>
                    <option value="1">Indian/Alaska</option>
                    <option value="2">Asian</option>
                    <option value="3">Black</option>
                    <option value="4">Hispanic</option>
                    <option value="5">White</option>
                    <option value="6">Hawaiian</option>
                    <option value="99">2+ Races</option>
                </select>
                Gender:
                <select id="gender" name="gender">
                    <option value="ALL">ALL</option>
                    <option value="F">Female</option>
                    <option value="M">Male</option>
                </select>
            </p>
            <p>
                Disability:
                <select id="disabil" name="disabil">
                    <option value="ALL">ALL</option>
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select>
                LEP:
                <select id="lep" name="lep">
                    <option value="ALL">ALL</option>
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select>
                Disadvantaged:
                <select id="disadva" name="disadva">
                    <option value="ALL">ALL</option>
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select>
            </p>
            <p>
                <input type="submit">
            </p>
        </form>

        <%
            Query query = new Query(request);
        %>
        <script>
            document.getElementById("div_num").value = "<%= query.div_num %>";
            document.getElementById("sch_num").value = "<%= query.sch_num %>";
            document.getElementById("race").value = "<%= query.race %>";
            document.getElementById("gender").value = "<%= query.gender %>";
            document.getElementById("disabil").value = "<%= query.disabil %>";
            document.getElementById("lep").value = "<%= query.lep %>";
            document.getElementById("disadva").value = "<%= query.disadva %>";
        </script>

        <h1>Results</h1>
        <table style="text-align: center">
            <thead>
                <tr bgcolor="lightyellow">
                    <th>sch_year</th>
                    <th>ENGR</th>
                    <th>ENGW</th>
                    <th>HIST</th>
                    <th>MATH</th>
                    <th>SCI</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean odd = true;
                    for (int[] row : query.getData()) {
                        if (odd) {
                            out.println("<tr class=\"odd\">");
                        } else {
                            out.println("<tr class=\"even\">");
                        }
                        odd = !odd;
                        for (int data : row) {
                            out.println("<td>" + data + "</td>");
                        }
                        out.println("</tr>");
                    }
                %>
            </tbody>
        </table>

        <h1>Chart</h1>
        <div id="chart_div" style="width: 700px; height: 350px;"></div>

        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'line']});
            google.charts.setOnLoadCallback(drawChart);

            function drawChart() {
                var data = new google.visualization.DataTable();

                data.addColumn('string', 'sch_year');
                data.addColumn('number', 'ENGR');
                data.addColumn('number', 'ENGW');
                data.addColumn('number', 'HIST');
                data.addColumn('number', 'MATH');
                data.addColumn('number', 'SCI');

                data.addRows([
            <%
                for (int[] row : query.getData()) {
                    out.print("['" + row[0] + "', ");
                    for (int i = 1; i < 5; i++) {
                        out.print(row[i] + ", ");
                    }
                    out.println(row[5] + "],");
                }
            %>
                ]);

                var options = {
                    hAxis: {
                        title: 'Year'
                    },
                    vAxis: {
                        title: 'Score'
                    },
                };

                var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
                chart.draw(data, options);
            }
        </script>

    </body>
</html>
