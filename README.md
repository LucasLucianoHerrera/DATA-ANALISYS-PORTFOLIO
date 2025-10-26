# 📂 Data Analysis Portfolio (SQL & Python)

Welcome to my professional Data Analysis Portfolio, focused on end-to-end projects covering data ingestion, transformation, complex SQL querying, and visualization.

This repository demonstrates my ability to work with industry-standard tools and maintain a robust, reproducible development environment using Docker and version control.

---

## 🛠️ CORE TECHNOLOGIES & TOOLS

| Technology | Purpose |
| :--- | :--- |
| **SQL Server 2022** | Primary engine for data storage, transformation, and analysis (T-SQL). |
| **Docker** | Used to containerize the SQL Server environment for cross-platform reproducibility (macOS). |
| **Visual Studio Code** | IDE for SQL development and Git version control. |
| **Python** (Planned) | Data processing, cleaning, and eventual API integration. |
| **Tableau** (Planned) | Visualization and dashboard creation based on final SQL outputs. |
| **Git & GitHub** | Version control and collaborative platform. |

---

## 📈 PROJECTS

Below are the data analysis projects included in this portfolio. Each subfolder contains a detailed `README.md` file explaining the methodology and findings.

### 1. [COVID-19 Global Data Analysis](COVID-DATA-ANALISIS/README.md)
* **Focus:** Mortality rates, infection rates, and population vaccination tracking.
* **Key Skills:** Complex Joins, Window Functions (`PARTITION BY`), Data Casting.
* **Status:** In Progress (SQL analysis phase).

---

## ⚙️ REPRODUCIBILITY GUIDE

This project requires **Docker** to run the database instance.

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/LucasLucianoHerrera/DATA-ANALISYS-PORTFOLIO
    ```
2.  **Start the SQL Server Container:**
    ```bash
    # Ensure your container is named 'mssql' and running on port 1433
    docker start mssql
    # (If the container is not running, use the 'docker run' command from our earlier steps)
    ```
3.  **Load Data:** Connect to the server (`localhost,1433`) and execute the scripts in the `COVID-DATA-ANALISIS/01-creacion-bd-y-tablas.sql` to create the database and import the data.