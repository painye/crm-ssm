package com.yp.crm.workbench.service;

import com.yp.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

/**
 * @author pan
 * @date 2022/3/6 11:04
 */
public interface ClueService {

    /**
     * 添加线索
     * @param clue
     * @return
     */
    int addClue(Clue clue);

    /**
     * 利用条件对线索进行分页查询
     * @param map
     * @return
     */
    List<Clue> queryClueByConditionForPage(Map<String, Object> map);

    /**
     * 查询符合条件的线索的数量
     * @param map
     * @return
     */
    int queryClueCountByCondition(Map<String, Object> map);
}
