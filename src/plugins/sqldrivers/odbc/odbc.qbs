import qbs

QtSqlPlugin {
    condition: project.sqlPlugins.contains("odbc")
    name: "qsqlodbc"
    files: [
        "main.cpp",
        "odbc.json",
    ]

    Group {
        name: "Sources from QtSql"
        prefix: "../../../sql/drivers/odbc/"
        files: [
            "qsql_odbc.cpp",
            "qsql_odbc_p.h",
        ]
    }

    Properties {
        condition: qbs.targetOS.contains("unix")
        cpp.defines: base.concat("UNICODE")
    }

    cpp.dynamicLibraries: {
        var libs = base || [];
        if (qbs.targetOS.contains("unix")) {
            if (libs.toString().search(/odbc/) != -1)
                return libs;
            if (qbs.targetOS.contains("darwin"))
                libs.push("iodbc");
            else
                libs = libs.concat(project.lFlagsOdbc.map(function(flag) { return flag.slice(2); }));
        } else {
            libs.push("odbc32");
        }
        return libs;
    }
}

// PLUGIN_CLASS_NAME = QODBCDriverPlugin

