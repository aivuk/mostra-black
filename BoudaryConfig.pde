void configBoudary() {

  String outBoudaryF = "BoundaryConfig.csv";
  File f = new File(dataPath("") + outBoudaryF); //retorna true se já existe 
  // println(f.getPath());
  //  println(outputFile);
  boolean alreadyExists = f.exists();

  try {
    // use FileWriter constructor that specifies open for appending
    OutputStreamWriter out = new OutputStreamWriter(new FileOutputStream(dataPath("") + outputFile, true), "UTF-8"); 
    CsvWriter csvOutput = new CsvWriter(out, ',');
    //  println(outputFile);
    // if the file didn't already exist then we need to write out the header line
    if (!alreadyExists)
    {
      println("Arquivo CSV não existe, criando ele");
      csvOutput.write("Dia");
      csvOutput.write("Mes");
      csvOutput.write("Hora");
      csvOutput.write("Minuto");
      csvOutput.write("Segundo");
      csvOutput.write("Frase");
      csvOutput.endRecord();

      csvOutput.close();
    }
    else {
      println("Arquivo CSV já criado!");
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

