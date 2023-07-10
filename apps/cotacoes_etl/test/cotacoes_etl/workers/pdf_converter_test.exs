defmodule CotacoesETL.Workers.PDFConverterTest do
  use ExUnit.Case, async: true

  alias CotacoesETL.Workers.PDFConverter

  @moduletag :integration

  describe "convert_pdf_to_txt/2" do
    @pdf_file_path Path.join(__DIR__, "./01_Boletim_Outubro_2021.pdf")
    @txt_file_path "/tmp/peapescarte/test/"

    test "converte com successo um arquivo PDF para TXT" do
      assert System.find_executable("gs")

      assert {:ok, _pid} = PDFConverter.start_link(nil)
      assert :ok = PDFConverter.convert_pdf_to_txt(@pdf_file_path, @txt_file_path, self())

      assert_receive {:pdf_converted, path}, 500
      assert path =~ @txt_file_path
    end
  end
end
