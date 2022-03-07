package com.yp.crm.workbench.mapper;

import com.yp.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 06 10:27:41 CST 2022
     */
    int deleteClueById(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 06 10:27:41 CST 2022
     */
    int insert(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 06 10:27:41 CST 2022
     */
    Clue selectClueById(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 06 10:27:41 CST 2022
     */
    int updateClue(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Sun Mar 06 10:27:41 CST 2022
     */
    int updateByPrimaryKey(Clue record);

    /**
     * 插入新的线索
     * @param clue
     * @return
     */
    int insertClue(Clue clue);

    /**
     * 根据条件对线索表进行分页查询
     * @param map
     * @return
     */
    List<Clue> queryClueByConditionForPage(Map<String, Object> map);

    /**
     * 查询符合条件的线索的总数
     * @param map
     * @return
     */
    int queryClueCountsByCondition(Map<String, Object> map);



}