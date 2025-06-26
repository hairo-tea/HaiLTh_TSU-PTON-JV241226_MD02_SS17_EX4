import database.ConnectionDB;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;


public class AccountManager {
    public void transferFunds(int id_from, int id_to, double amount) {
        Connection connection = null;
        CallableStatement call = null;
        try{
            connection = ConnectionDB.getConnection();
            if(connection != null) {
                connection.setAutoCommit(false);
                call = connection.prepareCall("{call transfer_funds(?,?,?,?)}");
            call.setInt(1, id_from);
            call.setInt(2, id_to);
            call.setDouble(3, amount);
            call.registerOutParameter(4, Types.VARCHAR);
            call.executeUpdate();
            connection.commit();

            String rs = call.getString(4);
            System.out.println(rs);
            }

        } catch (Exception e) {
            try{
                if(connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                throw new RuntimeException();
            }
            System.err.println("Chuyển tiền thất bại.");
        }finally {
            try{
                if(call != null) call.close();
                if(connection != null) connection.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}
