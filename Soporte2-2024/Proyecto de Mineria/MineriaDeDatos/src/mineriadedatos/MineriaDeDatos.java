/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mineriadedatos;
import weka.classifiers.bayes.NaiveBayes;
import weka.core.converters.ConverterUtils.DataSource;
import weka.core.Instance;
import weka.core.Instances;


/**
 *
 * @author BRAYAN
 */
public class MineriaDeDatos {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception {
        // TODO code application logic here
        System.out.println("Hola mundo");
        DataSource ds = new DataSource("C:\\Users\\BRAYAN\\Documents\\NetBeansProjects\\MineriaDeDatos\\src\\mineriadedatos\\credit.g.arff");
        Instances ins =ds.getDataSet();
        ins.setClassIndex(3);
        NaiveBayes nb = new NaiveBayes();
        nb.buildClassifier(ins);
        System.out.println(nb.toString());
    }
    
}
