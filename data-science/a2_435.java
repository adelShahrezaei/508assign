import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class a2_435 {

    public static class DataSet {
        public int colNum;
        public int rowNum;
        public ArrayList<String[]> set;
        public ArrayList<Double[]> setD;

        public ArrayList<HashMap<String, Object>> missings;

        public DataSet(ArrayList<String[]> set) {
            this.set = set;
        }

        public DataSet(String filePath) throws IOException {
            this.set = readCsv(filePath);
            this.missings = new ArrayList<>();
            this.setD = new ArrayList<>();
            this.rowNum = set.size();
            this.colNum = set.get(1).length;
            findAllMissings();
            convertToDouble();
        }

        public void impute(){

            for(HashMap<String,Object> miss: missings){
                //Mean
                miss.put("mean", mean(col((int)miss.get("col"))));

                //Mean Conditional
                miss.put("mean_conditional",
                        mean(
                                colCond(
                                        (int)miss.get("col"),
                                        set.get((int)miss.get("row"))[13]
                                )
                        )
                );

                //Hot Deck
                miss.put("hd",
                        hotDeck(
                                (int) miss.get("row"),
                                (int) miss.get("col")
                        )
                );
                //Hot Deck Conditional
                miss.put("hd_conditional",
                        hotDeckCond(
                                (int) miss.get("row"),
                                (int) miss.get("col"),
                                set.get((int)miss.get("row"))[13]

                        )
                );

            }

        }

        public ArrayList<Double> col(int col){
            ArrayList<Double> c = new ArrayList<Double>();
            for (Double[] r : this.setD){
                c.add(r[ col]);
            }

            return c;
        }

        public ArrayList<Double> colCond(int col, String cond){
            ArrayList<Double> c = new ArrayList<Double>();
            for (int i=0; i<setD.size();i++){

                if(set.get(i)[13].equals(cond)) {
                    c.add(setD.get(i)[col]);
                }
            }

            return c;
        }

        public void findAllMissings(){
            for (int i =0 ; i<this.rowNum; i++ ){
                for(int j = 0; j<this.colNum; j++){

                    if (this.set.get(i)[j].equals("?")){

                        HashMap <String, Object> miss = new HashMap<>();
                        miss.put("row",  i);
                        miss.put("col",  j);

                        missings.add(miss);
                    }
                }
            }
        }
        public void convertToDouble(){
            for (int i =0 ; i<this.rowNum; i++ ) {
                Double[] row = new Double[this.colNum];
                for (int j = 0; j < this.colNum-1; j++) {
                    row[j] = (set.get(i)[j].equals("?")?null:Double.parseDouble(set.get(i)[j])) ;
                }
                this.setD.add(row);
            }
        }
        public double mean(ArrayList<Double> arr){
            double sum=0;
            int n = 0;
            for (int i = 0; i < arr.size(); i++) {
                if (arr.get(i)!=null){
                    sum+= arr.get(i);
                    n++;
                }

            }
            return sum/n;
        }

        public double hotDeck(int row, int col){
            double minDist = Double.POSITIVE_INFINITY;
            int minIndex = -1;
            double dist= 0;
            Double curr[] = setD.get(row);
            for (int i = 0; i < setD.size(); i++) {
                if(i==row)
                    continue;
                dist = eculDist(curr,setD.get(i));
                if(dist<minDist) {
                    if (setD.get(i)[col] != null) {
                        minDist = dist;
                        minIndex = i;
                    }
                }
            }

            return  setD.get(minIndex)[col];

        }

        public double hotDeckCond(int row, int col, String cond){
            double minDist = Double.POSITIVE_INFINITY;
            int minIndex = -1;
            double dist= 0;
            Double curr[] = setD.get(row);
            for (int i = 0; i < setD.size(); i++) {
                if(i==row || !set.get(i)[13].equals(cond))
                    continue;
                dist = eculDist(curr,setD.get(i));
                if(dist<minDist) {
                    if (setD.get(i)[col] != null) {
                        minDist = dist;
                        minIndex = i;
                    }
                }
            }
//            System.out.printf("%d %d\n",row,col);
            return  setD.get(minIndex)[col];

        }

        public double eculDist(Double[] a, Double[] b){
            double dist= 0;
            for (int i = 0; i < a.length; i++) {
                dist+= (a[i] != null && b[i] != null)? Math.pow(a[i]-b[i],2) : 1;
            }
            return Math.sqrt(dist);
        }




        public double MAE(DataSet complete, String algo){
            double AE = 0 ;
            int n = 0 ;
            for (HashMap<String ,Object> miss: missings  ){
                double x = (double) miss.get(algo);
                double t = complete.setD.get((int) miss.get("row"))[(int) miss.get("col")];
                AE += Math.abs(x-t);
                n++;

            }
            return AE/n;

        };

        public void saveAlgo(ArrayList<String[]> setT, String fileName,String algo) throws FileNotFoundException {

            PrintWriter out = new PrintWriter("00722422_"+fileName+"_imputed_"+algo+".csv");
            for (HashMap<String ,Object> miss: missings  ){
                setT.get((int)miss.get("row"))[(int)miss.get("col")]=String.format("%.5f",(double) miss.get(algo));
            }
            for (String[] row: setT){
                out.print(mytoString(row,",")+"\n");
            }
            out.close();
        }

        public void save(String fileName) throws FileNotFoundException {

            ArrayList<String[]> setT = new ArrayList<String[]>(set);
            saveAlgo(setT, fileName,"mean");
            saveAlgo(setT, fileName,"mean_conditional");
            saveAlgo(setT, fileName,"hd");
            saveAlgo(setT, fileName,"hd_conditional");


        }
    }


    public  static  ArrayList<String[]> readCsv(String filePath) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(filePath));

        // read file line by line
        ArrayList<String[]> set  = new ArrayList<String[]>();
        String line = null;
        reader.readLine(); // skip the first line
        while ((line = reader.readLine()) != null) {
            String[] array = line.split(",");
            set.add(array);
        }
        return set;
    }

    public static void main(String[] args) throws IOException {
        // Read all csv
        DataSet setC = new DataSet("dataset_complete.csv");
        DataSet setA = new DataSet("dataset_missing01.csv");
        DataSet setB = new DataSet("dataset_missing10.csv");

        setA.impute();

        System.out.printf("MAE_01_mean = %.4f\n",setA.MAE(setC,"mean"));
        System.out.printf("MAE_01_mean_conditional = %.4f\n",setA.MAE(setC,"mean_conditional"));
        System.out.printf("MAE_01_hd = %.4f\n",setA.MAE(setC,"hd"));
        System.out.printf("MAE_01_hd_conditional = %.4f\n",setA.MAE(setC,"hd_conditional"));

        setB.impute();

        System.out.printf("MAE_10_mean = %.4f\n",setB.MAE(setC,"mean"));
        System.out.printf("MAE_10_mean_conditional = %.4f\n",setB.MAE(setC,"mean_conditional"));
        System.out.printf("MAE_10_hd = %.4f\n",setB.MAE(setC,"hd"));
        System.out.printf("MAE_10_hd_conditional = %.4f\n",setB.MAE(setC,"hd_conditional"));

        setA.save("missing01");
        setB.save("missing10");

        return;
    }

    private static String mytoString(String[] theAray, String delimiter) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < theAray.length; i++) {
            if (i > 0) {
                sb.append(delimiter);
            }
            String item = theAray[i];
            sb.append(item);
        }
        return sb.toString();
    }
}
