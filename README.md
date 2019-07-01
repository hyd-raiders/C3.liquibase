# C3.liquibase
liquibase test  , spring boot

## profile

本例为 spring boot + gradle + liquibase + oracle 例子



## 如何集成

[liquibase-gradle-plugin](https://github.com/liquibase/liquibase-gradle-plugin)  [liquibase](https://www.liquibase.org/)

build.gradle添加依赖 

```groovy
plugins {
	id 'org.springframework.boot' version '2.1.6.RELEASE'
	id 'java' 
	id 'org.liquibase.gradle' version '2.0.1'  //liquibase
}

dependencies {
	implementation 'org.springframework.boot:spring-boot-starter-web'
	implementation 'org.mybatis.spring.boot:mybatis-spring-boot-starter:2.0.1'
	testImplementation 'org.springframework.boot:spring-boot-starter-test'
	compile 'cn.easyproject:ojdbc6:12.1.0.2.0' //liquibase
	liquibaseRuntime 'cn.easyproject:ojdbc6:12.1.0.2.0'  //liquibase
	liquibaseRuntime 'org.liquibase:liquibase-core:3.6.1'  //liquibase
	liquibaseRuntime 'org.liquibase:liquibase-groovy-dsl:2.0.1' //liquibase
	liquibaseRuntime 'ch.qos.logback:logback-core:1.2.3'  //liquibase
	liquibaseRuntime 'ch.qos.logback:logback-classic:1.2.3' //liquibase
}

//生成对比记录文件的位置
project.ext.diffChangelogFile = 'src/main/resources/liquibase/changelog/' + new Date().format('yyyyMMddHHmmss') + '_changelog.xml'
//生成sql文件的位置
project.ext.generateSql = 'src/main/resources/liquibase/sql/' + new Date().format('yyyyMMddHHmmss') + '_update.sql'

liquibase {
	activities {
		dev {
			driver 'oracle.jdbc.OracleDriver'
			url 'jdbc:oracle:thin:@192.168.10.128:1521:ORCL'
			username 'hello'
			password 'goodday'
			changeLogFile 'src/main/resources/liquibase/master.xml'
			defaultSchemaName ''
			logLevel 'debug'
			outputFile project.ext.generateSql
		}
        fat {
			driver 'oracle.jdbc.OracleDriver'
			url 'jdbc:oracle:thin:@192.168.10.128:1521:ORCL'
			username 'hello'
			password 'hello'
			changeLogFile 'src/main/resources/liquibase/master.xml'
			defaultSchemaName ''
			logLevel 'debug'
			outputFile project.ext.generateSql
		}
        prod {
			//driver 'com.microsoft.sqlserver.jdbc.SQLServerDriver'  //driver
			url 'jdbc:sqlserver://localhost:1433;database=damManager'
			username 'hello'
			password 'hellos'
			changeLogFile 'src/main/resources/liquibase/master.xml'
			defaultSchemaName ''
			logLevel 'debug'
			outputFile project.ext.generateSql
		}
		diffLog {
			driver 'oracle.jdbc.OracleDriver'
			url 'jdbc:oracle:thin:@192.168.10.128:1521:ORCL'
			username 'hello'
			password 'goodday'
			changeLogFile project.ext.diffChangelogFile
			defaultSchemaName ''
			logLevel 'debug'
		}
		runList = project.ext.runList //'dev' // project.ext.runList  gradle update -PrunList=dev // 这里代表选择哪一个配置 可用参数代替
	}
}

```

添加文件

```bash
# 创建目录
mkdir -p src/main/resource/liquibase/changelog
mkdir -p src/main/resource/liquibase/sql

# 创建master.xml 或者 使用 gradle generateChangeLog 生成

touch src/main/resource/liquibase/master.xml

cat src/main/resource/liquibase/master.xml
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.4.xsd">

    <!--实际sql-->
    <include file="src/main/resources/liquibase/changelog/init-table.sql" relativeToChangelogFile="false"/>
    <!--实际sql-->
    <include file="src/main/resources/liquibase/changelog/init-data.sql" relativeToChangelogFile="false"/>
</databaseChangeLog>
```

```bash
# 编辑sql
cat src/main/resource/liquibase/changelog/init-table.sql
```

```sql
--liquibase formatted sql

--changeset yourname:1
create table test1 (
    id int primary key,
    name varchar(255)
);
--rollback drop table test1;

--changeset yourname:2
insert into test1 (id, name) values (1, 'name 1');
insert into test1 (id, name) values (2, 'name 2');
```

```bash
# 编辑sql
cat src/main/resource/liquibase/changelog/init-data.sql
```

```sql
--liquibase formatted sql

--changeset yourname:3
insert into test1 (id, name) values (3, 'name 3');
insert into test1 (id, name) values (4, 'name 4');

--changeset yourname:5
insert into test1 (id, name) values (6, 'name 6');
insert into test1 (id, name) values (7, 'name 7');
```

```bash
gradle update
```



## 常用操作

```bash
gradle update #（将xml的改变更新到数据库）

gradle rollback #（回滚到某一版本或者某一时刻，必须要带上rollbackTag参数）
gradle rollback -PliquibaseCommandValue=V1.0.0

gradle dbDoc #（生成数据库文档）

gradle dropAll #（慎用，清空当前数据库，包括liquibase的版本信息）

gradle generateChangeLog #（根据数据库反向生成changeLog文件）

gradle tag #（为当前数据库打上标签）
# gradle tag -PliquibaseCommandValue=V1.0.0
```



## 脚本管理规约（仅推荐）

1. changelog  命名以版本号命令
2. 每次脚本需要备注实际操作人名字
3. 任何脚本都需要添加rollback
4. 生产环境、发布版本后需要tag，tag名与版本号一致

5. 其他请参考数据库规约