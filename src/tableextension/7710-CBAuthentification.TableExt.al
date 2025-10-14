tableextension 76000 "CB Authentification" extends "ADCS User" //7710
{
    fields
    {


        field(76000; "CB Password"; Text[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Password := rec."CB Password";
            end;
        }
    }

}