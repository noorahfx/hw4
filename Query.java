package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;

public class Query {

    public int div_num;
    public int sch_num;
    public String race;
    public String gender;
    public String disabil;
    public String lep;
    public String disadva;

    private int[][] data;

    public Query(HttpServletRequest request) {
        div_num = parseInt(request, "div_num");
        sch_num = parseInt(request, "sch_num");
        race = parseStr(request, "race");
        gender = parseStr(request, "gender");
        disabil = parseStr(request, "disabil");
        lep = parseStr(request, "lep");
        disadva = parseStr(request, "disadva");
    }

    private int parseInt(HttpServletRequest request, String name) {
        String str = request.getParameter(name);
        try {
            return Integer.parseInt(str);
        } catch (NumberFormatException exc) {
            return 0;
        }
    }

    private String parseStr(HttpServletRequest request, String name) {
        String str = request.getParameter(name);
        if (str != null) {
            return str;
        } else {
            return "ALL";
        }
    }

    public int[][] getData() {
        // return cached copy if exists
        if (data != null) {
            return data;
        }
        String sql = "SELECT * FROM hw5sol(?, ?, ?, ?, ?, ?, ?)";
        try {
            // set the query parameters
            Connection db = Database.open();
            PreparedStatement st = db.prepareStatement(sql);
            st.setInt(1, div_num);
            st.setInt(2, sch_num);
            st.setString(3, race);
            st.setString(4, gender);
            st.setString(5, disabil);
            st.setString(6, lep);
            st.setString(7, disadva);

            // execute query, save results
            ResultSet rs = st.executeQuery();
            data = new int[9][6];
            for (int row = 0; row < 9; row++) {
                data[row][0] = 2006 + row;  // school year
                for (int col = 1; col < 6; col++) {
                    rs.next();
                    data[row][col] = rs.getInt(3);  // sol score
                }
            }

            // close database resources
            rs.close();
            st.close();
            db.close();
            return data;
        } catch (SQLException exc) {
            // lazy hack to simplify hw5
            throw new RuntimeException(exc);
        }
    }

    public int[][] testData() {
        return new int[][] {
            {2006, 479, 467, 481, 470, 448},
            {2007, 480, 472, 483, 472, 453},
            {2008, 476, 466, 481, 462, 451},
            {2009, 472, 470, 482, 459, 457},
            {2010, 474, 473, 435, 451, 449},
            {2011, 471, 461, 434, 414, 448},
            {2012, 422, 446, 433, 419, 428},
            {2013, 424, 435, 443, 422, 439},
            {2014, 421, 429, 444, 429, 438}};
    }

}
