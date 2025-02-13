vcpkg_download_distfile(ARCHIVE
    URLS "https://pkg.cppget.org/1/stable/odb/libodb-${VERSION}.tar.gz"
    FILENAME "libodb-${VERSION}.tar.gz"
    SHA512 7c8b931f314ee23de2cdaa409ee3ebafbb73c7f17c8ca1699209c1d83862f3d00cdd74d6a0680bfc4bf1dab43d31d2e6a2ef85437c8e7e5e43d1113125bea5dd
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DCMAKE_CXX_STANDARD=11 # 17 removes 'auto_ptr'
    OPTIONS_DEBUG
        -DLIBODB_INSTALL_HEADERS=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-libodb)

set(LIBODB_HEADER_PATH "${CURRENT_PACKAGES_DIR}/include/odb/details/export.hxx")
file(READ "${LIBODB_HEADER_PATH}" LIBODB_HEADER)
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    string(REPLACE "#ifdef LIBODB_STATIC_LIB" "#if 1" LIBODB_HEADER "${LIBODB_HEADER}")
else()
    string(REPLACE "#ifdef LIBODB_STATIC_LIB" "#if 0" LIBODB_HEADER "${LIBODB_HEADER}")
endif()
file(WRITE "${LIBODB_HEADER_PATH}" "${LIBODB_HEADER}")

vcpkg_copy_pdbs()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")